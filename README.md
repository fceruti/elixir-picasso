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
  upload_dir: "path/to/your/media/dir",
  upload_url: "localhost:4000/media/images",

```


Generate migrations

```bash
mix picasso.gen.migration
```
