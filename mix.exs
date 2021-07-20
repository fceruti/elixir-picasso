defmodule Picasso.MixProject do
  use Mix.Project

  def project do
    [
      app: :picasso,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix, "~> 1.5.8"},
      {:phoenix_html, "~> 2.11"},
      {:mogrify, "~> 0.9.1"}
    ]
  end
end
