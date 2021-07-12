defmodule Mix.Tasks.Picasso.Gen.Migration do
  @moduledoc """
    Generates Picasso's migrations to host project.

      mix picasso.gen.migration
  """
  use Mix.Task

  def run(_) do
    # Copy originals migrations
    tmpl_originals =
      Path.expand(
        Path.join([__ENV__.file, "../../../../priv/templates/migrations", "originals.exs"])
      )

    out_originals =
      Path.join([File.cwd!(), "priv/repo/migrations", "#{timestamp()}_create_originals.exs"])

    File.cp(
      tmpl_originals,
      out_originals
    )

    # Copy renditions migrations
    tmpl_renditions =
      Path.expand(
        Path.join([__ENV__.file, "../../../../priv/templates/migrations", "renditions.exs"])
      )

    out_renditions =
      Path.join([File.cwd!(), "priv/repo/migrations", "#{timestamp()}_create_renditions.exs"])

    File.cp(
      tmpl_renditions,
      out_renditions
    )

    Mix.shell().info("""
    Picasso migrations generated at:

    #{out_originals}
    #{out_renditions}
    """)
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)
end
