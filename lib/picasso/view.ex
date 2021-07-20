defmodule Picasso.View do
  alias Picasso.{Context, Config}

  def rendition_url(original, filters) do
    {:ok, rendition, _created} = Context.get_or_create_rendition(original, filters)
    image_url = get_file_url(rendition)
    image_url
  end

  defp get_file_url(%{filename: filename}) do
    url = Path.join([Config.upload_url(), filename])
    url
  end
end
