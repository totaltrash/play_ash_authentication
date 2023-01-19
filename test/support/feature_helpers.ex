defmodule Test.FeatureHelpers do
  use Wallaby.DSL

  def assert_forbidden(session) do
    session
    |> assert_text("Access denied")
  end

  def assert_on(session, :home), do: assert_heading(session, "A Blog")
  def assert_on(session, :admin), do: assert_heading(session, "Admin")

  def assert_on(session, :login),
    do: assert_has(session, Query.css("#user-password-sign-in-with-password_username"))

  def assert_on(session, :register),
    do: assert_has(session, Query.css("#user-password-register-with-password_username"))

  def assert_heading(session, heading) do
    assert_has(session, Query.css("h1", text: heading))
  end

  def assert_flash(session, message), do: assert_text(session, message)

  def assert_form_error(session, error), do: assert_text(session, error)
end
