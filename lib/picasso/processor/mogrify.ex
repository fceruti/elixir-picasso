defmodule Picasso.Processor.Mogrify do
  import Mogrify

  def generate_rendition(image_path, filters) do
    open(image_path) |> resize(filters) |> save(in_place: true)
  end
end
