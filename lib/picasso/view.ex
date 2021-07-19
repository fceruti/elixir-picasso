defmodule Picasso.View do
  alias Picasso.Context

  def rendition_url(original, filters) do
    {:ok, rendition, _created} = Context.get_or_create_rendition(original, filters)
    image_url = Context.get_image_url(rendition)
    image_url
  end
end
