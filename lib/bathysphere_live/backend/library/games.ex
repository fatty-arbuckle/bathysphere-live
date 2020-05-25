defmodule BathysphereLive.Backend.Library.Games do

  @games %{
    "0c" => %BathysphereLive.Backend.Game.State{
      dice_pool_size: 5,
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, false}], marked?: false } },
        { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, false}, {:oxygen, -2, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:discovery, :fish, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -2, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [{:ocean_floor, +2, false}], marked?: false } },
        { :space, %{ actions: [{:ocean_floor, +4, false}], marked?: false } },
        { :space, %{ actions: [{:ocean_floor, +6, false}], marked?: false } },
        { :space, %{ actions: [{:ocean_floor, +6, false}], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, false}], marked?: false } },
        { :space, %{ actions: [{:ocean_floor, +6, false}], marked?: false } }
      ],
      oxygen: Enum.map(0..12, fn _ -> {:oxygen, false} end),
      stress: Enum.map(0..20, fn _ -> {:stress, false} end),
      damage: Enum.map(0..6, fn _ -> {:damage, false} end),
      fish_points: [+2, +3, +4, +5, +6, +7],
      octopus_points: [+1, +2, +3, +4, +8, +12]
    }
  }

  def list() do
    Map.keys(@games)
  end


  def load(name) do
    @games[name]
  end

end
