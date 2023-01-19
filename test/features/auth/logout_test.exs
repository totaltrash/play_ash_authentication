defmodule Test.Feature.Auth.LogoutTest do
  use Test.FeatureCase

  @moduletag login: true

  feature "logout", %{session: session} do
    session
    |> visit(~p"/")
    |> assert_has(logout_link())
    |> assert_has(login_link() |> Query.count(0))
    |> click(logout_link())
    |> assert_has(login_link())
    |> assert_has(logout_link() |> Query.count(0))
  end

  defp login_link, do: Query.link("Login")
  defp logout_link, do: Query.link("Logout")
end
