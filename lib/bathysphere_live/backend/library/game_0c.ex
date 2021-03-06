
defmodule BathysphereLive.Backend.Library.Game0c do

  def name do
    "0c"
  end

  def game do
    %BathysphereLive.Backend.Game.State{
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
      resources: %{
        dice_pool_size: 5,
        oxygen: Enum.map(0..12, fn _ -> %BathysphereLive.Backend.Game.Resource{type: :oxygen} end),
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage, penalties: [:dice]},
          %BathysphereLive.Backend.Game.Resource{type: :damage, penalties: [:dice]},
          %BathysphereLive.Backend.Game.Resource{type: :damage, penalties: [:dice]},
          %BathysphereLive.Backend.Game.Resource{type: :damage, penalties: [:dice]},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
        ]
      },
      fish_points: [+2, +3, +4, +5, +6, +7],
      octopus_points: [+1, +2, +3, +4, +8, +12]
    }
  end

end
