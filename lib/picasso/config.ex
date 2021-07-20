defmodule Picasso.Config do
  @spec repo :: Ecto.Repo
  def repo() do
    case env(:ecto_repo) do
      nil -> raise "Must define :ecto_repo for Picasso to work properly."
      repo -> repo
    end
  end

  def processor() do
    case env(:processor) do
      nil -> raise "Must define :processor for Picasso to work properly."
      processor -> processor
    end
  end

  def datastore() do
    case env(:datastore) do
      nil -> raise "Must define :datastore for Picasso to work properly."
      datastore -> datastore
    end
  end

  def upload_dir() do
    case env(:upload_dir) do
      nil -> raise "Must define :upload_dir for Picasso to work properly."
      upload_dir -> upload_dir
    end
  end

  def upload_url() do
    case env(:upload_url) do
      nil -> raise "Must define :upload_url for Picasso to work properly."
      upload_url -> upload_url
    end
  end

  defp env(key, default \\ nil) do
    Application.get_env(:picasso, key, default)
  end
end
