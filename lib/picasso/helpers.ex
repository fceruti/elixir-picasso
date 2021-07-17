defmodule Picasso.Helpers do
  def get_file_info(file_path) do
    hash = File.stream!(file_path, [], 2048) |> sha256()

    with {:ok, %File.Stat{size: size}} <- File.stat(file_path) do
      {:ok, [hash, size]}
    else
      {:error, _reason} = error -> error
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
end
