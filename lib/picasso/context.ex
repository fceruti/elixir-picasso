defmodule Picasso.Context do
  @moduledoc """
  Picasso's public API.
  """
  import Mogrify

  alias Picasso.Schema.Original
  alias Picasso.Config

  def get_original!(id) do
    Original
    |> Config.repo().get!(id)
  end

  def create_original(
        %Plug.Upload{filename: filename, path: tmp_path, content_type: content_type},
        alt \\ nil
      ) do
    {:ok, filename} = get_unique_filename(filename)
    {:ok, [hash, size]} = get_file_info(tmp_path)
    {:ok, [width, height]} = get_image_dimensions(tmp_path)

    {:ok, filename} = Config.backend().store(tmp_path, filename)

    with {:ok, original} <-
           %Original{}
           |> Original.changeset(%{
             filename: filename,
             size: size,
             hash: hash,
             content_type: content_type,
             width: width,
             height: height,
             alt: alt
           })
           |> Config.repo().insert() do
      {:ok, original}
    else
      {:error, _reason} = error ->
        Config.backend().remove(filename)
        error
    end
  end

  def update_original(
        original_id,
        %Plug.Upload{
          filename: filename,
          path: tmp_path,
          content_type: content_type
        },
        alt
      ) do
    original = get_original!(original_id)
    {:ok, [hash, size]} = get_file_info(tmp_path)

    if original.hash != hash do
      old_filename = original.filename
      {:ok, filename} = get_unique_filename(filename)
      {:ok, [width, height]} = get_image_dimensions(tmp_path)

      {:ok, filename} = Config.backend().store(tmp_path, filename)

      with {:ok, original} <-
             original
             |> Original.changeset(%{
               filename: filename,
               size: size,
               hash: hash,
               content_type: content_type,
               width: width,
               height: height,
               alt: alt
             })
             |> Config.repo().update() do
        Config.backend().remove(old_filename)
        {:ok, original}
      else
        {:error, _reason} = error ->
          Config.backend().remove(filename)
          error
      end
    else
      with {:ok, original} <-
             original
             |> Original.changeset(%{alt: alt})
             |> Config.repo().update() do
        {:ok, original}
      else
        {:error, _reason} = error ->
          error
      end
    end

    {:ok, original}
  end

  def update_original(original_id, nil, alt) do
    original = get_original!(original_id)

    with {:ok, original} <-
           original
           |> Original.changeset(%{alt: alt})
           |> Config.repo().update() do
      {:ok, original}
    else
      {:error, _reason} = error ->
        error
    end
  end

  def delete_original(original_id) do
    original = get_original!(original_id)
    old_filename = original.filename
    # TODO: remove all renditions
    case original |> Config.repo().delete() do
      {:ok, original} ->
        Config.backend().remove(old_filename)
        {:ok, original}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  # -----------------------
  # Helpers
  # -----------------------
  defp get_unique_filename(filename) do
    {:ok, Ecto.UUID.generate() <> "-" <> filename}
  end

  defp get_file_info(file_path) do
    hash = File.stream!(file_path, [], 2048) |> sha256()

    with {:ok, %File.Stat{size: size}} <- File.stat(file_path) do
      {:ok, [hash, size]}
    else
      {:error, _reason} = error -> error
    end
  end

  defp get_image_dimensions(file_path) do
    %{height: height, width: width} = identify(file_path)
    {:ok, [width, height]}
  end

  def sha256(chunks_enum) do
    chunks_enum
    |> Enum.reduce(
      :crypto.hash_init(:sha256),
      &:crypto.hash_update(&2, &1)
    )
    |> :crypto.hash_final()
    |> Base.encode16()
    |> String.downcase()
  end
end
