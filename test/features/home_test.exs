defmodule Test.Feature.HomeTest do
  use Test.FeatureCase

  feature "view home", %{session: session} do
    session
    |> visit(~p"/")
    |> assert_text("Peace of mind from prototype to production")
  end
end
