defmodule Picasso.Processor.Mogrify do
  import Mogrify

  def generate_rendition(image_path, filters) do
    open(image_path) |> resize(filters) |> save
  end
end
