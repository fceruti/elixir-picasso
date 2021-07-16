defmodule Picasso.Kaffy.Original do
  alias Picasso.Context

  def insert(conn, _changeset) do
    %{"original" => %{"filename" => filename, "alt" => alt}} = conn.params
    {:ok, original} = Context.create_original(filename, alt)
    {:ok, original}
  end

  def update(conn, _changeset) do
    %{"original" => %{"filename" => filename, "alt" => alt}} = conn.params
    {:ok, original} = Context.update_original(filename, alt)
    {:ok, original}
  end

  def delete(conn, _changeset) do
    Context.delete_original(conn.params["id"])
    :ok
  end

  def index(_) do
    [
      id: nil,
      filename: nil,
      content_type: nil,
      size: nil,
      width: nil,
      height: nil,
      inserted_at: nil
    ]
  end

  def form_fields(_) do
    [
      filename: %{type: :file, label: "Image file"},
      alt: nil
    ]
  end
end
