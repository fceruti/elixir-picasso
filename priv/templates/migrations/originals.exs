defmodule Picasso.Repo.Migrations.AddOriginals do
  use Ecto.Migration

  def change do
    create table("picasso_originals") do
      add :filename, :string
      add :size, :bigint
      add :hash, :string, size: 64
      add :content_type, :string
      add :width, :integer
      add :height, :integer
      add :alt, :string, null: true

      timestamps()
    end
    create index("picasso_originals", [:hash])

  end
end
