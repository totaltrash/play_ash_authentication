defmodule Test.FeatureCase do
  @moduledoc """
  This module defines the test case to be used by features.
  """

  use ExUnit.CaseTemplate
  use Wallaby.DSL
  use MyAppWeb, :verified_routes
  import Test.Factory

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Feature
      import Test.Factory
      import Test.FeatureHelpers

      # The default endpoint for testing
      @endpoint MyAppWeb.Endpoint

      use MyAppWeb, :verified_routes
    end
  end

  setup tags do
    Test.DataCase.setup_sandbox(tags)

    context =
      %{}
      |> set_session_context()
      |> set_user_context(tags)
      |> do_login(tags)

    {:ok, context}
  end

  defp set_session_context(context) do
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(MyApp.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)

    Map.put(context, :session, session)
  end

  defp set_user_context(context, tags) do
    if tags[:user] == false do
      context
    else
      {user, raw_password} =
        case tags[:user] do
          nil -> insert_user(with_raw_password: true)
          user_tags -> insert_user(Keyword.merge([with_raw_password: true], user_tags))
        end

      context
      |> Map.put(:user, user)
      |> Map.put(:raw_password, raw_password)
    end
  end

  defp do_login(%{session: session, user: user, raw_password: raw_password} = context, tags) do
    if tags[:login] == true do
      session =
        session
        |> visit(~p"/login")
        |> submit_login_form(user.username, raw_password)
        |> assert_login_success()

      Map.put(context, :session, session)
    else
      context
    end
  end

  defp do_login(context, _tags) do
    context
  end

  defp submit_login_form(session, username, password) do
    session
    |> fill_in(Query.text_field("Username"), with: username)
    |> fill_in(Query.text_field("Password"), with: password)
    |> click(Query.button("Sign in"))
  end

  defp assert_login_success(session) do
    assert_has(session, Query.css("h1", text: "A Blog"))
  end
end
