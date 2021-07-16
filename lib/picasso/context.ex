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

    {:ok, dest} = Config.backend().store(tmp_path, filename)

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
        Config.backend().remove(dest)
        error
    end
  end

  def update_original(original_id, %Plug.Upload{
        filename: filename,
        path: tmp_path,
        content_type: content_type
      }) do
    IO.inspect(original_id)
    IO.inspect(filename)
    IO.inspect(tmp_path)
    IO.inspect(content_type)
  end

  def delete_original(original_id) do
    IO.inspect(original_id)
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
