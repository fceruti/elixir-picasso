# Picasso

Dead simple image resizing & cropping tool for phoenix projects.

## Usage

```elixir
img_url = Picasso.View.rendition_url(original, "70x70")
Phoenix.HTML.Tag.img_tag(img_url)
```

## Features

* Plug & Play
* Simple API to generate image renditions
* Integration with Kaffy

## Roadmap

This library is under development. Use it if you know what you are doing.

* Add S3 backend
* Add rendition options to `generate_rendition/2`
* Do all image transformations in elixir, droping all external dependencies (image magik)
* Add testing
* Add docs

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
  datastore: Picasso.Datastore.File,
  processor: Picasso.Processor.Mogrify,
  upload_dir: Path.join([File.cwd!(), "priv/media/picasso"]),
  upload_url: "localhost:4000/media/images",

```

Generate migrations

```bash
mix picasso.gen.migration
```


Add Picasso admin resources to your kaffy config:

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

Add image serving plug in your `endpoint.ex` for local dev:

```elixir

plug Plug.Static,
  at: "/media/images",
  from: Path.expand('priv/media/picasso'),
  gzip: false

```

* Note that `at` is related to config's `:upload_url` and `from` to `upload_dir`


You'll also want to update the max upload file size at `endpoint.ex`


```elixir
  plug Plug.Parsers,
    parsers: [:urlencoded, {:multipart, length: 20_000_000}, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
```