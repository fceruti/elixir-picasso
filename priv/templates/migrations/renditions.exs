defmodule Picasso.Repo.Migrations.AddReditions do
  use Ecto.Migration

  def change do
    create table("picasso_renditions") do
      add :original_id, references("picasso_originals", on_delete: :delete_all)
      add :filter_spec, :string, null: false
      add :filename, :string, null: false
      add :size, :bigint, null: false
      add :hash, :string, size: 64, null: false
      add :content_type, :string, null: false
      add :width, :integer, null: false
      add :height, :integer, null: false

      timestamps()
    end

    create index("picasso_renditions", [:original_id, :filter_spec])
  end
end
