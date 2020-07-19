defmodule BathysphereLiveWeb.WelcomeLive do
  use BathysphereLiveWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <h1 class="title">
        <a href="/new-game">New Game</a>
      </h1>
    """
  end

end
