defmodule Picasso.Helpers do
  def get_file_info(file_path) do
    try do
      hash = File.stream!(file_path, [], 2048) |> sha256()

      with {:ok, %File.Stat{size: size}} <- File.stat(file_path) do
        {:ok, [hash, size]}
      else
        {:error, _reason} = error -> error
      end
    rescue
      e -> {:error, e.reason}
    end
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

  def get_rendition_filename(original_filename, filters) do
    [extension | reversed_filename] = original_filename |> String.split(".") |> Enum.reverse()
    filename = reversed_filename |> Enum.reverse() |> Enum.join(".")

    if String.length(filename) == 0 do
      "#{extension}-#{filters}"
    else
      "#{filename}-#{filters}.#{extension}"
    end
  end

  def get_unique_filename(filename) do
    {:ok, Ecto.UUID.generate() <> "-" <> filename}
  end
end
