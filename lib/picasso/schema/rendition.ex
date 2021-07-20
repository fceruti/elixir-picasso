defmodule Picasso.Schema.Rendition do
  use Ecto.Schema

  import Ecto.Changeset

  alias Picasso.Schema.Original

  @type t :: %__MODULE__{
          id: integer,
          original_id: integer,
          original: Original.t() | %Ecto.Association.NotLoaded{},
          filter_spec: String.t(),
          filename: String.t(),
          size: integer,
          hash: String.t(),
          content_type: String.t(),
          width: integer,
          height: integer
        }

  schema("picasso_renditions") do
    belongs_to(:original, Original)
    field(:filter_spec, :string)
    field(:filename, :string)
    field(:size, :integer)
    field(:hash, :string)
    field(:content_type, :string)
    field(:width, :integer)
    field(:height, :integer)

    timestamps()
  end

  @doc false
  def changeset(original, attrs) do
    original
    |> cast(attrs, [
      :original_id,
      :filter_spec,
      :filename,
      :size,
      :hash,
      :content_type,
      :width,
      :height
    ])
    |> validate_required([
      :original_id,
      :filter_spec,
      :filename,
      :size,
      :hash,
      :content_type,
      :width,
      :height
    ])
    |> validate_number(:size, greater_than: 0)
    |> validate_number(:width, greater_than: 0)
    |> validate_number(:height, greater_than: 0)
    |> validate_length(:hash, is: 64)
  end
end
