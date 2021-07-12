defmodule Picasso.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Picasso.Repo
    ]

    opts = [strategy: :one_for_one, name: Picasso.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
