defmodule Picasso.Repo do
  use Ecto.Repo,
    otp_app: :picasso,
    adapter: Ecto.Adapters.Postgres
end
