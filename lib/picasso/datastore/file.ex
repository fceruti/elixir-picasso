defmodule Picasso.Datastore.File do
  @behaviour Picasso.Datastore.Behaviour

  require Logger

  alias Picasso.{Config, Helpers}

  @impl true
  def read(filename) do
    base_dir = Config.upload_dir()
    original_path = Path.join([base_dir, filename])
    {:ok, tmp_path} = Temp.path()

    case File.cp(original_path, tmp_path) do
      :ok ->
        {:ok, tmp_path}

      {:error, reason} ->
        Logger.error("Failed reading #{filename} at #{base_dir}: #{reason}")
        {:error, reason}
    end
  end

  @impl true
  def store(tmp_path, filename) do
    base_dir = Config.upload_dir()
    final_path = Path.join([base_dir, filename])

    case File.cp(tmp_path, final_path) do
      :ok ->
        {:ok, [hash, size]} = Helpers.get_file_info(final_path)
        Logger.info("Stored #{filename} at #{base_dir}. Size: #{size}. Hash: #{hash}.")
        {:ok, filename}

      {:error, reason} ->
        Logger.error("Failed storing #{filename} at #{base_dir}: #{reason}")
        {:error, reason}
    end
  end

  @impl true
  def remove(filename) do
    base_dir = Config.upload_dir()
    path = Path.join([base_dir, filename])

    with {:ok, [hash, size]} <- Helpers.get_file_info(path) do
      case File.rm(path) do
        :ok ->
          Logger.info("Removed #{filename} at #{path}. Size: #{size}. Hash: #{hash}.")
          {:ok, filename}

        {:error, reason} = error ->
          Logger.error("Failed removing #{filename} at #{base_dir}: #{reason}")
          error
      end
    else
      {:error, reason} = error ->
        Logger.error("Failed removing #{filename} at #{base_dir}: #{reason}")
        error
    end
  end
end
