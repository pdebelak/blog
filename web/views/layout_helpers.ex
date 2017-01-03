defmodule Blog.LayoutHelpers do
  use Phoenix.HTML

  def notification(notification_class, do: content) do
    render_react("Notification", %{ "notificationClass" => notification_class, "content" => content |> safe_to_string() })
  end

  def signed_in(conn, do: content) do
    if Blog.CurrentUser.current_user(conn) do
      content
    else
      ""
    end
  end

  def render_react(component, props, options \\ [tag: :div]) do
    content_tag(options[:tag], "", [{:data, [react: true, component: component, props: Poison.encode!(props)] }])
  end
end
