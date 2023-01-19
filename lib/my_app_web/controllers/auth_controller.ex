defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller

  require Logger

  def success(conn, _activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: return_to)
  end

  def failure(
        conn,
        {:password, :sign_in},
        %AshAuthentication.Errors.AuthenticationFailed{}
      ) do
    conn
    |> put_flash(:error, "Username or password is incorrect")
    |> redirect(to: ~p"/login")
  end

  def failure(conn, activity, reason) do
    stacktrace =
      case reason do
        %{stacktrace: %{stacktrace: stacktrace}} -> stacktrace
        _ -> nil
      end

    Logger.error("""
    Something went wrong in authentication
    activity: #{inspect(activity)}
    reason: #{Exception.format(:error, reason, stacktrace || [])}
    """)

    conn
    |> put_flash(:error, "Something went wrong")
    |> redirect(to: ~p"/login")
  end

  # def failure(conn, _activity, _reason) do
  #   conn
  #   |> put_status(401)
  #   |> render("failure.html")
  # end

  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> clear_session()
    |> redirect(to: return_to)
  end
end
