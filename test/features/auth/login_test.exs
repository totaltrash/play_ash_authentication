defmodule Test.Feature.Auth.LoginTest do
  use Test.FeatureCase

  feature "successful login", %{session: session, user: user, raw_password: raw_password} do
    session
    |> visit(~p"/")
    |> assert_on(:home)
    |> click(login_link())
    |> assert_on(:login)
    |> fill_and_submit_form(user.username, raw_password)
    |> assert_on(:home)
  end

  feature "login and redirect to requested path", %{
    session: session,
    user: user,
    raw_password: raw_password
  } do
    session
    |> visit(~p"/admin/posts")
    |> assert_on(:login)
    |> fill_and_submit_form(user.username, raw_password)
    |> assert_on(:admin)
  end

  feature "failed login invalid username", %{session: session} do
    session
    |> visit(~p"/login")
    |> fill_and_submit_form("invalid", "whatever")
    |> assert_login_failed()
  end

  feature "failed login invalid password", %{session: session, user: user} do
    session
    |> visit(~p"/login")
    |> fill_and_submit_form(user.username, "whatever")
    |> assert_login_failed()
  end

  defp login_link(), do: Query.link("Login")

  defp assert_login_failed(session) do
    assert_text(session, "Username or password is incorrect")
  end

  defp fill_and_submit_form(session, username, password) do
    session
    |> fill_in(Query.text_field("Username"), with: username)
    |> fill_in(Query.text_field("Password"), with: password)
    |> click(Query.button("Sign in"))
  end
end
