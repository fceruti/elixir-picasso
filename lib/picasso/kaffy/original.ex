defmodule Picasso.Kaffy.Original do
  alias Picasso.Context

  def insert(conn, _changeset) do
    case Context.create_original(
           get_in(conn.params, ["original", "filename"]),
           get_in(conn.params, ["original", "alt"])
         ) do
      {:ok, _original} = success -> success
      {:error, _changeset} = error -> error
    end
  end

  def update(conn, _changeset) do
    case Context.update_original(
           get_in(conn.params, ["id"]),
           get_in(conn.params, ["original", "filename"]),
           get_in(conn.params, ["original", "alt"])
         ) do
      {:ok, _original} = success -> success
      {:error, _changeset} = error -> error
    end
  end

  def delete(conn, _changeset) do
    case Context.delete_original(conn.params["id"]) do
      {:ok, _original} = success -> success
      {:error, _changeset} = error -> error
    end
  end

  def index(_) do
    [
      filename: nil,
      content_type: nil,
      size: %{name: "File Size (mb)", value: fn o -> size_in_mb(o.size) end},
      dimensions: %{name: "Dimension (w x h)", value: fn o -> "#{o.width} x #{o.height}" end},
      inserted_at: nil
    ]
  end

  def form_fields(_) do
    [
      filename: %{type: :file, label: "Image file"},
      alt: nil
    ]
  end

  defp size_in_mb(size_in_kylobytes) do
    (size_in_kylobytes / 1_000_000) |> Decimal.from_float() |> Decimal.round(2)
  end
end
