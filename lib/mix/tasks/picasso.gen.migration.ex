if Code.ensure_loaded?(Ecto) do
  defmodule Mix.Tasks.Picasso.Gen.Migration do
    use Mix.Task

    @doc "Adds migrations to host project "
    def run(_) do
      # calling our Hello.say() function from earlier
      IO.inspect("Add migrations")
    end
  end
end
