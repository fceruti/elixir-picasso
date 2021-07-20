defmodule Picasso.Repo.Migrations.AddOriginals do
  use Ecto.Migration

  def change do
    create table("picasso_originals") do
      add :filename, :string, null: false
      add :size, :bigint, null: false
      add :hash, :string, size: 64, null: false
      add :content_type, :string, null: false
      add :width, :integer, null: false
      add :height, :integer, null: false
      add :alt, :string, null: true

      timestamps()
    end
  end
end
