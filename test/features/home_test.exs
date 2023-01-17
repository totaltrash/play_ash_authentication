defmodule Test.Feature.HomeTest do
  use Test.FeatureCase

  feature "view blog posts on home", %{session: session} do
    author = insert_user()
    post = insert_post(author: author)

    session
    |> visit(~p"/")
    |> assert_text(post.title)
    |> assert_text(author.name)
  end
end
