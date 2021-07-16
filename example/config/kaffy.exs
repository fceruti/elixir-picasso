use Mix.Config

config :kaffy,
  otp_app: :example,
  ecto_repo: Example.Repo,
  router: ExampleWeb.Router,
  resources: &Example.Kaffy.Config.create_resources/1

defmodule Example.Kaffy.Config do
  def create_resources(_conn) do
    [] ++ Picasso.Kaffy.Config.resources()
  end
end
