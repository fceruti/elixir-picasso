defmodule Picasso.Processor.Mogrify do
  import Mogrify

  def generate_rendition(image_path, filters) do
    image =
      open(image_path)
      |> gravity("Center")
      |> resize_to_fill(filters)
      |> save(in_place: true)

    {:ok, image}
  end

  def get_image_dimensions(image_path) do
    %{height: height, width: width} = identify(image_path)
    {:ok, [width, height]}
  end
end
