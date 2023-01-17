defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  def home(conn, _params) do
    posts = MyApp.Blog.Post.read_all!()
    render(conn, :home, posts: posts, layout: false)
  end
end
