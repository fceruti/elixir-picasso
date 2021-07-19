defmodule Picasso.ImageField do
  use Ecto.Type
  def type, do: :string

  def cast(data) do
    # IO.inspect("cast - data: #{inspect(data)}")
    {:ok, data}
  end

  def load(data) do
    # IO.inspect("load - data: #{inspect(data)}")
    {:ok, data}
  end

  # When dumping data to the database, we *expect* an URI struct
  # but any value could be inserted into the schema struct at runtime,
  # so we need to guard against them.
  # def dump(%URI{} = uri), do: {:ok, Map.from_struct(uri)}
  def dump(data), do: {:ok, data}

  # this function should return the HTML related to rendering the customized form field.
  def render_form(conn, changeset, form, field, _options) do
    img_div =
      if form.data.filename do
        [
          {:safe, ~s(<p><b>Current image:</b> #{form.data.filename}</p>)},
          {:safe, ~s(<div class="form-group">)},
          Phoenix.HTML.Tag.img_tag(
            # Routes.static_url(conn, "/" <> Upload.thumbnail_path(form.data.filename))
          ),
          {:safe, ~s(</div>)}
        ]
      else
        {:safe, ''}
      end

    [
      img_div,
      {:safe, ~s(<div class="form-group">)},
      Phoenix.HTML.Form.label(form, field, "Filename"),
      Phoenix.HTML.Form.file_input(form, field,
        class: "form-control",
        name: "#{form.name}[#{field}]"
      ),
      {:safe, ~s(</div>)}
    ]
  end

  # this is how the field should be rendered on the index page
  def render_index(conn, resource, field, _options) do
    case Map.get(resource, field) do
      nil ->
        ""

      details ->
        filename = details

        [
          Phoenix.HTML.Tag.img_tag(Picasso.View.rendition_url(resource, "50x50"))
        ]
    end
  end

  defp get_field_value(changeset, field) do
    field_value = Map.get(changeset.data, field)
    field_value
  end
end
