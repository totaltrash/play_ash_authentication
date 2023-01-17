defmodule Test.FeatureHelpers do
  use Wallaby.DSL

  def assert_forbidden(session) do
    session
    |> assert_text("Access denied")
  end
end
