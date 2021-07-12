defmodule Picasso.Repo.Migrations.AddReditions do
  use Ecto.Migration

  def change do
    create table("picasso_renditions") do
      add :original_id, references("picasso_originals", on_delete: :delete_all)
      add :filter_spec, :string
      add :filename, :string
      add :size, :bigint
      add :hash, :string, size: 64
      add :content_type, :string
      add :width, :integer
      add :height, :integer

      timestamps()
    end
    create index("picasso_renditions", [:hash])

  end
end
