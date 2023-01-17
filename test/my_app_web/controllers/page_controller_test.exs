defmodule MyAppWeb.PageControllerTest do
  use Test.ConnCase

  test "GET /", %{conn: conn} do
    author = insert_user()
    post = insert_post(author: author)

    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ post.title
  end
end
