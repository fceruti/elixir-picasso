import Config

config :picasso, Picasso.Repo,
  database: "picasso_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :picasso, ecto_repos: [Picasso.Repo]
