defmodule Blog.FormHelpers do
  use Phoenix.HTML

  def input_tag(form, field, options \\ []) do
    form_field_tag(form, field) do
      text_input(form, field, [class: "input"] ++ options)
    end
  end

  def password_tag(form, field, options \\ []) do
    form_field_tag(form, field) do
      password_input(form, :password, [class: "input"] ++ options)
    end
  end

  def textarea_tag(form, field, options \\ []) do
    form_field_tag(form, field) do
      textarea(form, field, [class: "textarea"] ++ options)
    end
  end

  def checkbox_tag(form, field, options \\ []) do
    content_tag(:p, class: "control") do
      label(form, field, class: "checkbox") do
        [
          checkbox(form, field, [class: "checkbox"] ++ options),
          [" ", humanize(field)]
        ]
      end
    end
  end

  def submit_button(text) do
    submit text, class: "button is-primary"
  end

  defp form_field_tag(form, field, do: input) do
    [
      label(form, field, class: "label"),
      content_tag(:p, class: "control") do
        [
          input,
          Blog.ErrorHelpers.error_tag(form, field) || ""
        ]
      end
    ]
  end
end
