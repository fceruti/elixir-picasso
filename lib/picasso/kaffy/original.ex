defmodule Picasso.Kaffy.Original do
  alias Picasso.Context

  def insert(conn, _changeset) do
    %{"original" => %{"filename" => filename, "alt" => alt}} = conn.params
    {:ok, original} = Context.create_original(filename, alt)
    {:ok, original}
  end

  def update(conn, _changeset) do
    case conn.params do
      %{"id" => original_id, "original" => %{"filename" => filename, "alt" => alt}} ->
        {:ok, original} = Context.update_original(original_id, filename, alt)
        {:ok, original}

      %{"id" => original_id, "original" => %{"alt" => alt}} ->
        {:ok, original} = Context.update_original(original_id, nil, alt)
        {:ok, original}
    end
  end

  def delete(conn, _changeset) do
    case Context.delete_original(conn.params["id"]) do
      {:ok, original} -> {:ok, original}
      {:error, changeset} -> {:error, changeset}
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
