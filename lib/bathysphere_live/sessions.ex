defmodule BathysphereLive.Sessions do

  # TODO pull the game_state out of the session

  def enumerate() do
    Stream.resource(
      fn -> :ets.first(:bathysphere_auth_table) end,
      fn :"$end_of_table" -> {:halt, nil}
         previous_key -> {[previous_key], :ets.next(:bathysphere_auth_table, previous_key)} end,
      fn _ -> :ok end
    )
    |> Enum.to_list
  end

end
