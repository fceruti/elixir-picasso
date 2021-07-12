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

Generate migrations

```
mix picasso.gen.migration
```
