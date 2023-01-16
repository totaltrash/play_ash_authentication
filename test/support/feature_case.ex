defmodule Test.FeatureCase do
  @moduledoc """
  This module defines the test case to be used by features.
  """

  use ExUnit.CaseTemplate
  use Wallaby.DSL

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Feature

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

    {:ok, context}
  end

  defp set_session_context(context) do
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(MyApp.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)

    Map.put(context, :session, session)
  end
end
