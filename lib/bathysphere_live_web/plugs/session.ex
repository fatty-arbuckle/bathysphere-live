defmodule BathysphereLiveWeb.Plugs.Session do
  import Plug.Conn, only: [get_session: 2, put_session: 3, halt: 1, assign: 3]
  import Phoenix.Controller, only: [redirect: 2]

  require Logger

  def redirect_unauthorized(conn, _opts) do
    user_id = Map.get(conn.assigns, :user)

    if user_id == nil do
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: BathysphereLiveWeb.Router.Helpers.welcome_path(conn, :index))
      |> halt()
    else
      conn
    end
  end

  def validate_session(conn, _opts) do
    case get_session(conn, :session_uuid) do
      nil ->
        conn
        |> put_session(:session_uuid, UUID.uuid4(:hex))

      session_uuid ->
        conn
        |> validate_session_token(session_uuid)
    end
  end

  def validate_session_token(conn, session_uuid) do
    case :ets.lookup(:bathysphere_auth_table, :"#{session_uuid}") do
      [{_, token}] ->
        case Phoenix.Token.verify(BathysphereLiveWeb.Endpoint, signing_salt(), token, max_age: 3_600) do
          {:ok, user} ->
            conn
            |> assign(:user, user)

          _ ->
            conn
        end

      _ ->
        conn
    end
  end

  def signing_salt do
    BathysphereLiveWeb.Endpoint.config(:live_view)[:signing_salt] ||
      raise BathysphereLiveWeb.AuthenticationError, message: "missing signing_salt"
  end
end
