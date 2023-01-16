defmodule Test.Feature.Blog.PostsTest do
  use Test.FeatureCase

  feature "view blog posts", %{session: session} do
    author = insert_user()
    post = insert_post(author: author)

    session
    |> visit(~p"/blog/")
    |> assert_text(post.title)
    |> assert_text(author.name)
  end
end
