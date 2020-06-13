defmodule BathysphereLive.Backend.Game.State do

  defstruct [
    state: :ok, # :no_map, :complete, :dead,
    map: [],
    position: 0,
    remaining: 0,
    direction: 0,
    score: 0,
    resources: %{
      dice_pool_size: 0,
      dice_pool: [],
      stress: [],
      damage: [],
      oxygen: []
    },
    fish_points: [],
    octopus_points: [],
    fish_count: 0,
    octopus_count: 0
  ]

end
