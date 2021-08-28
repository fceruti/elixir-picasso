defmodule Picasso.MixProject do
  use Mix.Project

  def project do
    [
      app: :picasso,
      version: "0.2.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Dead simple image resizing & cropping tool for phoenix projects.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Francisco Ceruti"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/fceruti/elixir-picasso"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, ">= 0.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix, ">= 0.0.0"},
      {:phoenix_html, ">= 0.0.0"},
      {:mogrify, "~> 0.9.1"},
      {:temp, "~> 0.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
