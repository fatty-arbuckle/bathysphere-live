defmodule BathysphereLiveWeb.NewGameController do
  use BathysphereLiveWeb, :controller

  require Logger

  import Plug.Conn, only: [get_session: 2]

  def index(conn, _params) do
    key = get_session(conn, :session_uuid)
    user = BathysphereLive.User.random
    salt = BathysphereLiveWeb.Endpoint.config(:live_view)[:signing_salt]
    token = Phoenix.Token.sign(BathysphereLiveWeb.Endpoint, salt, user)
    :ets.insert(:bathysphere_auth_table, {:"#{key}", token})
    BathysphereLive.Backend.Game.reset(user,BathysphereLive.Backend.Game.State.new(user))

    conn
    # |> create_new_sessions
    |> put_flash(:info, "Welcome #{user}")
    |> redirect(to: Routes.page_path(conn, :index))
  end

end
