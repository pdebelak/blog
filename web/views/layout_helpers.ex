defmodule Blog.LayoutHelpers do
  use Phoenix.HTML

  def half_width(do: content) do
    content_tag(:div, class: "columns") do
      [
        content_tag(:div, content, class: "column"),
        content_tag(:div, "", class: "column")
      ]
    end
  end
end
