defmodule Picasso.Context do
  @moduledoc """
  Picasso's public API.
  """
  import Ecto.Query

  require Logger

  alias Picasso.Schema.{Original, Rendition}
  alias Picasso.{Config, Helpers}

  def create_original(
        %Plug.Upload{filename: filename, path: tmp_path, content_type: content_type},
        alt \\ nil
      ) do
    {:ok, filename} = Helpers.get_unique_filename(filename)
    {:ok, [hash, size]} = Helpers.get_file_info(tmp_path)
    {:ok, [width, height]} = Config.processor().get_image_dimensions(tmp_path)

    with {:ok, filename} <- Config.datastore().store(tmp_path, filename) do
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
        Logger.info("Picasso Original(#{original.id}) created.")
        {:ok, original}
      else
        {:error, reason} ->
          Config.datastore().remove(filename)
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
    original = Config.repo().get_by!(Original, id: original_id)

    {:ok, filename} = Helpers.get_unique_filename(filename)

    with {:ok, filename} <- Config.datastore().store(tmp_path, filename) do
      old_filename = original.filename
      {:ok, [hash, size]} = Helpers.get_file_info(tmp_path)
      {:ok, [width, height]} = Config.processor().get_image_dimensions(tmp_path)

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
        Config.datastore().remove(old_filename)
        remove_all_renditions(original)
        Logger.info("Picasso Original(#{original.id}) updated.")
        {:ok, original}
      else
        {:error, _reason} = error ->
          Config.datastore().remove(filename)
          error
      end
    else
      {:error, _reason} = error -> error
    end
  end

  def update_original(original_id, nil, alt) do
    original = Config.repo().get_by!(Original, id: original_id)

    with {:ok, original} <-
           original
           |> Original.changeset(%{alt: alt})
           |> Config.repo().update() do
      remove_all_renditions(original)
      Logger.info("Picasso Original(#{original.id}) updated.")
      {:ok, original}
    else
      {:error, _reason} = error ->
        error
    end
  end

  def delete_original(original_id) do
    original = Config.repo().get_by!(Original, id: original_id)

    case original |> Config.repo().delete() do
      {:ok, original} ->
        Logger.info("Picasso Original(#{original.id}) deleted.")
        Config.datastore().remove(original.filename)
        remove_all_renditions(original)
        {:ok, original}

      {:error, _changeset} = error ->
        error
    end
  end

  def get_or_create_rendition(%Original{} = original, filters) do
    # TODO: validate filters

    case Config.repo().get_by(Rendition, original_id: original.id, filter_spec: filters) do
      nil ->
        {:ok, tmp_path} = Config.datastore().read(original.filename)
        {:ok, %{path: tmp_path}} = Config.processor().generate_rendition(tmp_path, filters)
        rendition_filename = Helpers.get_rendition_filename(original.filename, filters)
        {:ok, filename} = Config.datastore().store(tmp_path, rendition_filename)

        {:ok, [hash, size]} = Helpers.get_file_info(tmp_path)
        {:ok, [width, height]} = Config.processor().get_image_dimensions(tmp_path)

        with {:ok, rendition} <-
               %Rendition{}
               |> Rendition.changeset(%{
                 original_id: original.id,
                 filename: filename,
                 filter_spec: filters,
                 content_type: original.content_type,
                 size: size,
                 hash: hash,
                 width: width,
                 height: height
               })
               |> Config.repo().insert() do
          Logger.info(
            "Created Rendition for Original(#{original.id}). Filters:#{filters}. Hash: #{hash}."
          )

          {:ok, rendition, :created}
        else
          {:error, _reason} = error ->
            Config.datastore().remove(filename)
            error
        end

      %Rendition{} = rendition ->
        {:ok, rendition, :fetched}
    end
  end

  defp remove_all_renditions(%Original{id: original_id}) do
    rendition_query = from(r in Rendition, where: r.original_id == ^original_id)

    rendition_query
    |> select([:filename])
    |> Config.repo().all()
    |> Enum.map(&Config.datastore().remove(&1.filename))

    {n_deleted, _} = rendition_query |> Config.repo().delete_all()
    Logger.info("Removed #{n_deleted} Renditions of Original(#{original_id}).")
  end
end
