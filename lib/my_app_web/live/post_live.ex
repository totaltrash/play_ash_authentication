defmodule MyAppWeb.PostLive do
  use MyAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Blog Posts
    </.header>
    <.table id="posts" rows={@posts}>
      <:col :let={post} label="Title">
        <%= post.title %>
      </:col>
      <:col :let={post} label="Author">
        <%= post.author.name %>
      </:col>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, posts: MyApp.Blog.Post.read_all!())}
  end
end
