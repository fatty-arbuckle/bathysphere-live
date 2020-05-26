defmodule BathysphereLive.Backend.Game do
  use Supervisor

  def start_link(spaces) do
    GenServer.start_link(__MODULE__, spaces, name: __MODULE__)
  end

  # Resets the current game, and loads a new GameState
  def reset(%BathysphereLive.Backend.Game.State{} = initial_state) do
    GenServer.call(__MODULE__, {:reset, initial_state})
  end

  def state do
    GenServer.call(__MODULE__, :state)
  end

  def up(n, index) do
    GenServer.call(__MODULE__, {:up, n, index})
  end

  def down(n, index) do
    GenServer.call(__MODULE__, {:down, n, index})
  end

  def select_action(action) do
    GenServer.call(__MODULE__, {:select_action, action})
  end

  def reroll() do
    GenServer.call(__MODULE__, :reroll)
  end

  def init(_opt) do
    { :ok,
      {
        :ok,
        %BathysphereLive.Backend.Game.State{
          state: :no_map
        }
      }
    }
  end

  def handle_call({:reset, state}, _from, _old_state) do
    { state, game_state } = BathysphereLive.Backend.Game.Mechanics.roll(state, :init)
    {:reply, state, { state, game_state } }
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:up, n, index}, _from, {_state, game_state}) do
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.up(game_state, n, index)
    {:reply, reply, {reply, new_state}}
  end

  def handle_call({:down, n, index}, _from, {_state, game_state}) do
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.down(game_state, n, index)
    {:reply, reply, {reply, new_state}}
  end

  def handle_call({:select_action, action}, _from, {_state, game_state}) do
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.select_action(game_state, action)
    {:reply, reply, {reply, new_state}}
  end

  def handle_call(:reroll, _from, {_state, game_state}) do
    {reply, new_state} = BathysphereLive.Backend.Game.Mechanics.roll(game_state)
    {:reply, reply, {reply, new_state}}
  end

end
