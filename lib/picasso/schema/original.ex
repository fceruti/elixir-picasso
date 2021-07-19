defmodule Picasso.Schema.Original do
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          filename: String.t(),
          size: integer,
          hash: String.t(),
          content_type: String.t(),
          width: integer,
          height: integer,
          alt: String.t()
        }

  schema("picasso_originals") do
    field(:filename, Picasso.ImageField)
    field(:size, :integer)
    field(:hash, :string)
    field(:content_type, :string)
    field(:width, :integer)
    field(:height, :integer)
    field(:alt, :string, null: true)

    has_many(:renditions, Picasso.Schema.Rendition)

    timestamps()
  end

  @doc false
  def changeset(original, attrs) do
    original
    |> cast(attrs, [:filename, :size, :hash, :content_type, :width, :height, :alt])
    |> validate_required([:filename, :size, :hash, :content_type, :width, :height])
    |> validate_number(:size, greater_than: 0)
    |> validate_number(:width, greater_than: 0)
    |> validate_number(:height, greater_than: 0)
    |> validate_length(:hash, is: 64)
  end
end
