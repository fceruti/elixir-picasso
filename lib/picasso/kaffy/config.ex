defmodule Picasso.Kaffy.Config do
  def resources() do
    [
      picasso: [
        name: "Picasso Images",
        resources: [
          originals: [schema: Picasso.Schema.Original, admin: Picasso.Kaffy.Original]
        ]
      ]
    ]
  end
end
