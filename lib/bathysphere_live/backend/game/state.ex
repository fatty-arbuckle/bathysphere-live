defmodule BathysphereLive.Backend.Game.State do

  defstruct [
    state: :ok, # :no_map, :complete, :dead,
    dice_pool_size: 0,
    dice_pool: [],
    map: [],
    position: 0,
    remaining: 0,
    direction: 0,
    score: 0,
    stress: [],
    damage: [],
    oxygen: [],
    fish_points: [],
    octopus_points: [],
    fish_count: 0,
    octopus_count: 0
  ]

end
