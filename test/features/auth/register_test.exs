defmodule Test.Feature.Auth.RegisterTest do
  use Test.FeatureCase

  feature "successful registration", %{session: session} do
    session
    |> visit(~p"/")
    |> click(login_link())
    |> assert_on(:login)
    |> click(register_link())
    |> assert_on(:register)
    |> fill_and_submit_form("someusername", "Some User", "somepassword", "somepassword")
    |> assert_on(:home)
    |> assert_flash("Welcome!")
  end

  describe "validations" do
    feature "required fields", %{session: session} do
      insert_user(username: "duplicate")

      session
      |> visit_register()
      |> fill_and_submit_form("", "", "", "")
      |> assert_form_error("Username is required")
      |> assert_form_error("Name is required")
      |> assert_form_error("Password is required")
      |> assert_form_error("Password confirmation is required")
    end

    feature "duplicate username", %{session: session} do
      insert_user(username: "duplicate")

      session
      |> visit_register()
      |> fill_and_submit_form("duplicate", "Some User", "somepassword", "somepassword")
      |> assert_form_error("Username already exists")
    end

    feature "password confirmation does not match", %{session: session} do
      insert_user(username: "duplicate")

      session
      |> visit_register()
      |> fill_and_submit_form("duplicate", "Some User", "somepassword", "DIFFERENT")
      |> assert_form_error("Password confirmation does not match")
    end
  end

  defp visit_register(session) do
    session
    |> visit(~p"/login")
    |> assert_on(:login)
    |> click(register_link())
    |> assert_on(:register)
  end

  defp login_link, do: Query.link("Login")
  defp register_link, do: Query.link("Need an account?")

  defp fill_and_submit_form(session, username, name, password, password_confirmation) do
    session
    |> fill_in(Query.text_field("Username"), with: username)
    |> fill_in(Query.text_field("user-password-register-with-password_password"), with: password)
    |> fill_in(Query.text_field("user-password-register-with-password_password_confirmation"),
      with: password_confirmation
    )
    |> fill_in(Query.text_field("Name"), with: name)
    |> click(Query.button("Register"))
  end
end
