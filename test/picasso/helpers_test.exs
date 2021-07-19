defmodule PicassoTest.Helpers do
  use ExUnit.Case, async: true

  import Picasso.Helpers

  test "test get_rendition_filename\2 with regular filename" do
    assert get_rendition_filename("image.jpg", "50x50") == "image-50x50.jpg"
  end

  test "test get_rendition_filename\2 with dotted filename" do
    assert get_rendition_filename("image.dot.jpg", "50x50") == "image.dot-50x50.jpg"
  end

  test "test get_rendition_filename\2 with filename without extension" do
    assert get_rendition_filename("image", "50x50") == "image-50x50"
  end
end
