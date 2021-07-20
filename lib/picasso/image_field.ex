defmodule Picasso.ImageField do
  use Ecto.Type
  def type, do: :string

  def cast(data), do: {:ok, data}

  def load(data), do: {:ok, data}

  def dump(data), do: {:ok, data}

  # this function should return the HTML related to rendering the customized form field.
  def render_form(_conn, changeset, form, field, _options) do
    current_image_div =
      if form.data.filename do
        [
          {:safe, ~s(<p><b>Current image:</b> #{form.data.filename}</p>)},
          {:safe, ~s(<div class="form-group">)},
          Phoenix.HTML.Tag.img_tag(Picasso.View.rendition_url(changeset.data, "70x70")),
          {:safe, ~s(</div>)}
        ]
      else
        {:safe, ''}
      end

    [
      current_image_div,
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
  def render_index(_conn, resource, _field, _options) do
    img_url = Picasso.View.rendition_url(resource, "70x70")
    [Phoenix.HTML.Tag.img_tag(img_url)]
  end
end
