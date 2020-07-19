defmodule BathysphereLiveWeb.Restricted.Helper do

  def assign_current_user(assign_new, session, socket) do
    assign_new.(socket, :current_user, fn ->
      get_user(session)
    end)
  end

  def get_user(%{"session_uuid" => session_uuid}) do
    case :ets.lookup(:bathysphere_auth_table, :"#{session_uuid}") do
      [{_, token}] ->
        case Phoenix.Token.verify(BathysphereLiveWeb.Endpoint, signing_salt(), token, max_age: 3_600) do
          {:ok, user_id} ->
            user_id

          _ ->
            nil
        end

      _ ->
        nil
    end
  end

  defp signing_salt() do
    BathysphereLiveWeb.Endpoint.config(:live_view)[:signing_salt]
  end

end
