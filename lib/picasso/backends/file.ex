defmodule Picasso.Backend.File do
  alias Picasso.Schema.Original
  alias Picasso.Config

  def store(tmp_path, filename) do
    final_path = Path.join([Config.upload_dir(), filename])
    File.cp!(tmp_path, final_path)
    {:ok, filename}
  end

  def remove(filename) do
    path = Path.join([Config.upload_dir(), filename])
    File.rm!(path)
    {:ok, filename}
  end

  def get_url(%Original{filename: filename, hash: hash}) do
    "#{Config.upload_url()}/#{hash}-#{filename}"
  end
end
