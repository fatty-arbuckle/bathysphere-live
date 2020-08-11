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
        <div
          class="button is-large is-bordered-text"
          has-tooltip-multiline
          data-tooltip="Start a new game"
        >
          <a href="/new-game" style="text-decoration: none;">New Game</a>
        </div>

      </h1>
    """
  end

end
