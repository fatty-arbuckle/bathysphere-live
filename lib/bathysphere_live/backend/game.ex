defmodule BathysphereLive.Backend.Game do
  use Supervisor

  # TODO need to store a game state per user/session, which we do in ETS...
  # or should this state be looked up here instead in a map by user/session

  def start_link(spaces) do
    GenServer.start_link(__MODULE__, spaces, name: __MODULE__)
  end

  # Resets the current game, and loads a new GameState
  def reset(user, initial_state) do
    GenServer.call(__MODULE__, {:reset, user, initial_state})
  end

  def state(user) do
    GenServer.call(__MODULE__, {:state, user})
  end

  def up(user, n, index) do
    GenServer.call(__MODULE__, {:up, user, n, index})
  end

  def down(user, n, index) do
    GenServer.call(__MODULE__, {:down, user, n, index})
  end

  def select_action(user, action) do
    GenServer.call(__MODULE__, {:select_action, user, action})
  end

  def reroll(user) do
    GenServer.call(__MODULE__, {:reroll, user})
  end

  def init(_opt) do
    { :ok,
      %{}
    }
  end

  defp get_game_info_for_user(state, user) do
    Map.get(state, user)
  end

  defp set_game_info_for_user(state, user, game_info) do
    Map.put(state, user, game_info)
  end

  def handle_call({:reset, user, state}, _from, genserver_state) do
    { state, game_state } = BathysphereLive.Backend.Game.Mechanics.roll(state, :init)
    genserver_state = set_game_info_for_user(genserver_state, user, { state, game_state })
    {:reply, state, genserver_state }
  end

  def handle_call({:state, user}, _from, genserver_state) do
    {:reply, get_game_info_for_user(genserver_state, user), genserver_state}
  end

  def handle_call({:up, user, n, index}, _from, genserver_state) do
    {_, game_state } = get_game_info_for_user(genserver_state, user)
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.up(game_state, n, index)
    genserver_state = set_game_info_for_user(genserver_state, user, {reply, new_state})
    {:reply, reply, genserver_state}
  end

  def handle_call({:down, user, n, index}, _from, genserver_state) do
    {_, game_state } = get_game_info_for_user(genserver_state, user)
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.down(game_state, n, index)
    genserver_state = set_game_info_for_user(genserver_state, user, {reply, new_state})
    {:reply, reply, genserver_state}

  end

  def handle_call({:select_action, user, action}, _from, genserver_state) do
    {_, game_state } = get_game_info_for_user(genserver_state, user)
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.select_action(game_state, action)
    genserver_state = set_game_info_for_user(genserver_state, user, {reply, new_state})
    {:reply, reply, genserver_state}
  end

  def handle_call({:reroll, user}, _from, genserver_state) do
    {_, game_state } = get_game_info_for_user(genserver_state, user)
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.roll(game_state)
    genserver_state = set_game_info_for_user(genserver_state, user, {reply, new_state})
    {:reply, reply, genserver_state}
  end

end
