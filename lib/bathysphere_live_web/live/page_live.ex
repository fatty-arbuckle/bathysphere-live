defmodule BathysphereLiveWeb.PageLive do
  use BathysphereLiveWeb, :live_view

  # @game_state %{
  #   state: :ok,
  #   dice_pool_size: 5,
  #   dice_pool: [ 3, 5, 1 ],
  #   map: [
  #     { :start, %{} },
  #     { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
  #     { :space, %{ actions: [{:stress, -1, false}], marked?: true } },
  #     { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: true } },
  #     { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :depth_zone, %{} },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:damage, -1, false}], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :depth_zone, %{} },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:damage, -1, false}, {:oxygen, -2, false}], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
  #     { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :depth_zone, %{} },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
  #     { :depth_zone, %{} },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [], marked?: false } },
  #     { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
  #     { :space, %{ actions: [{:ocean_floor, +2, false}], marked?: false } },
  #     { :space, %{ actions: [{:ocean_floor, +4, false}], marked?: false } },
  #     { :space, %{ actions: [{:ocean_floor, +6, false}], marked?: false } },
  #     { :space, %{ actions: [{:ocean_floor, +6, false}], marked?: false } },
  #     { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
  #     { :space, %{ actions: [{:ocean_floor, +6, false}], marked?: false } }
  #   ],
  #   position: 4,
  #   remaining: 0,
  #   direction: 0,
  #   fish_count: 2,
  #   octopus_count: 3,
  #   score: 0,
  #   oxygen: Enum.map(0..2, fn _ -> {:oxygen, true} end) ++ Enum.map(0..9, fn _ -> {:oxygen, false} end),
  #   stress: Enum.map(0..4, fn _ -> {:stress, true} end) ++ Enum.map(0..14, fn _ -> {:stress, false} end),
  #   damage: Enum.map(0..1, fn _ -> {:damage, true} end) ++ Enum.map(0..4, fn _ -> {:damage, false} end),
  #   fish_points: [+2, +3, +4, +5, +6, +7],
  #   octopus_points: [+1, +2, +3, +4, +8, +12]
  # }

  @impl true
  def mount(_params, _session, socket) do
    BathysphereLive.Backend.Library.Games.load("0c")
    |> BathysphereLive.Backend.Game.reset()

    {:ok, game_state} = BathysphereLive.Backend.Game.state()
    {
      :ok,
      assign(socket,
        game_state: game_state
      )
    }
  end

  # @impl true
  # def handle_event("suggest", %{"q" => query}, socket) do
  #   {:noreply, assign(socket, results: search(query), query: query)}
  # end
  #
  # @impl true
  # def handle_event("search", %{"q" => query}, socket) do
  #   case search(query) do
  #     %{^query => vsn} ->
  #       {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}
  #
  #     _ ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:error, "No dependencies found matching \"#{query}\"")
  #        |> assign(results: %{}, query: query)}
  #   end
  # end
  #
  # defp search(query) do
  #   if not BathysphereLiveWeb.Endpoint.config(:code_reloader) do
  #     raise "action disabled when not in development"
  #   end
  #
  #   for {app, desc, vsn} <- Application.started_applications(),
  #       app = to_string(app),
  #       String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
  #       into: %{},
  #       do: {app, vsn}
  # end
end
