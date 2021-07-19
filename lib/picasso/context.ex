defmodule Picasso.Context do
  @moduledoc """
  Picasso's public API.
  """
  import Mogrify

  require Logger

  alias Picasso.Schema.Original
  alias Picasso.{Config, Helpers}

  def get_original!(id) do
    Original
    |> Config.repo().get!(id)
  end

  def create_original(
        %Plug.Upload{filename: filename, path: tmp_path, content_type: content_type},
        alt \\ nil
      ) do
    {:ok, filename} = get_unique_filename(filename)
    {:ok, [hash, size]} = Helpers.get_file_info(tmp_path)
    {:ok, [width, height]} = get_image_dimensions(tmp_path)

    with {:ok, filename} <- Config.backend().store(tmp_path, filename) do
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
        Logger.info("Picasso Original ##{original.id} created")
        {:ok, original}
      else
        {:error, reason} ->
          Config.backend().remove(filename)
          {:error, reason}
      end
    else
      {:error, reason} -> {:error, reason}
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
    # TODO: remove all renditions
    original = get_original!(original_id)

    {:ok, filename} = get_unique_filename(filename)

    with {:ok, filename} <- Config.backend().store(tmp_path, filename) do
      old_filename = original.filename
      {:ok, [hash, size]} = Helpers.get_file_info(tmp_path)
      {:ok, [width, height]} = get_image_dimensions(tmp_path)

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
        Logger.info("Picasso Original ##{original.id} updated")
        Config.backend().remove(old_filename)
      else
        {:error, _reason} = error ->
          Config.backend().remove(filename)
          error
      end
    else
      {:error, _reason} = error -> error
    end
  end

  def update_original(original_id, nil, alt) do
    original = get_original!(original_id)

    with {:ok, original} <-
           original
           |> Original.changeset(%{alt: alt})
           |> Config.repo().update() do
      Logger.info("Picasso Original ##{original.id} updated")

      {:ok, original}
    else
      {:error, _reason} = error ->
        error
    end
  end

  def delete_original(original_id) do
    # TODO: remove all renditions
    original = get_original!(original_id)
    old_filename = original.filename

    case original |> Config.repo().delete() do
      {:ok, original} ->
        Logger.info("Picasso Original ##{original.id} deleted.")
        Config.backend().remove(old_filename)
        {:ok, original}

      {:error, _changeset} = error ->
        error
    end
  end

  # -----------------------
  # Helpers
  # -----------------------
  defp get_unique_filename(filename) do
    {:ok, Ecto.UUID.generate() <> "-" <> filename}
  end

  defp get_image_dimensions(file_path) do
    %{height: height, width: width} = identify(file_path)
    {:ok, [width, height]}
  end
end