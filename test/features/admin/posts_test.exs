defmodule Test.Feature.Admin.PostsTest do
  use Test.FeatureCase

  feature "public are unauthorized to view blog posts", %{session: session} do
    session
    |> visit(~p"/admin/posts/")
    |> assert_forbidden()
  end
end
