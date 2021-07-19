# Picasso

Dead simple image resizing & cropping tool for phoenix projects.

## Installation instructions

Add `picasso` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:picasso, "~> 0.1.0"}
  ]
end
```

Add picasso config

```elixir

config :picasso,
  ecto_repo: YourApp.Repo,
  backend: Picasso.Backend.File,
  processor: Picasso.Processor.Mogrify,
  upload_dir: "path/to/your/media/dir",
  upload_url: "localhost:4000/media/images",

```

Generate migrations

```bash
mix picasso.gen.migration
```


Add Picasso admin backend in your kaffy config:

```elixir
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
```