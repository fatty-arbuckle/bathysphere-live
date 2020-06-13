defmodule MechanicsTest do
  use ExUnit.Case

  @base_state %BathysphereLive.Backend.Game.State{
    map: [],
    state: :ok,
    position: 0,
    remaining: 0,
    direction: 1,
    score: 0,
    resources: %{
      dice_pool_size: 1,
      dice_pool: [],
      oxygen: [
        %BathysphereLive.Backend.Game.Resource{type: :oxygen},
        %BathysphereLive.Backend.Game.Resource{type: :oxygen}
      ],
      stress: [
        %BathysphereLive.Backend.Game.Resource{type: :stress},
        %BathysphereLive.Backend.Game.Resource{type: :stress}
      ],
      damage: [
        %BathysphereLive.Backend.Game.Resource{type: :damage},
        %BathysphereLive.Backend.Game.Resource{type: :damage}
      ]
    },
    fish_points: [+2, +2, +3],
    octopus_points: [+3, +5],
    fish_count: 0,
    octopus_count: 0
  }

  test "moving down onto empty space" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, true}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true, tracking: [{:down}] } },
      ],
      position: 1
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 1, 0)
  end

  test "moving down onto a marked space" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true } },
      ]
    }
    expected_state = %{ game_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true, tracking: [{:down}] } },
      ],
      position: 1,
      resources: %{ game_state.resources |
        dice_pool: [{1, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false}
        ]
      }
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 1, 0)
  end

  test "moving down and discovering an octopus" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, true}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: true, tracking: [{:down}] } },
      ],
      position: 1,
      score: 3,
      fish_count: 0,
      octopus_count: 1
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 1, 0)
  end

  test "moving down and discovering an fish" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, true}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: true, tracking: [{:down}] } },
      ],
      position: 1,
      score: 2,
      fish_count: 1,
      octopus_count: 0
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 1, 0)
  end

  test "moving down past marked spaces" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{5, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:oxygen, -1, false}], marked?: true } },
        { :space, %{ actions: [{:stress, -1, true}], marked?: true } },
        { :space, %{ actions: [{:damage, -2, true}], marked?: true } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      resources: %{ @base_state.resources |
        dice_pool: [{5, 0, true}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:oxygen, -1, false}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, true}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -2, true}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
      ],
      position: 5
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 5, 0)
  end

  test "moving down past depth_zone" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{3, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      state: :dead,
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false } },
      ],
      position: 4,
      resources: %{ game_state.resources |
        dice_pool: [{3, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
        ]
      }
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "moving down past the bottom" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{3, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
      ],
      position: 2,
      resources: %{ game_state.resources |
        dice_pool: [{3, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false},
        ]
      }
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "completing the game" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{3, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: true } }
      ],
      position: 3
    }
    expected_state = %{ game_state |
      state: :complete,
      resources: %{ game_state.resources |
        dice_pool: [{3, 0, true}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:up}] } },
        { :space, %{ actions: [], marked?: false, tracking: [{:up}] } },
        { :space, %{ actions: [], marked?: true } }
      ],
      position: 0,
      direction: -1,
    }
    assert {:complete, expected_state} == BathysphereLive.Backend.Game.Mechanics.up(game_state, 3, 0)
    assert {:complete, expected_state} == BathysphereLive.Backend.Game.Mechanics.up(expected_state, 1, 0)
    assert {:complete, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(expected_state, 1, 0)
  end

  test "running out of stress" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{3, 0, false}]
      },
      map: [
        { :start, %{} },
        { :depth_zone, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      state: :dead,
      map: [
        { :start, %{} },
        { :depth_zone, %{} },
        { :space, %{ actions: [{:stress, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
      ],
      position: 5,
      resources: %{ game_state.resources |
        dice_pool: [{3, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
        ]
      }
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "running out of damage" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{4, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:damage, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      state: :dead,
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
      ],
      position: 4,
      resources: %{ game_state.resources |
        dice_pool: [{4, 0, true}],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
        ]
      }
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 4, 0)
  end

  test "running out of oxygen" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{3, 0, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:oxygen, -2, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      state: :dead,
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:oxygen, -2, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
      ],
      position: 3,
      resources: %{ game_state.resources |
        dice_pool: [{3, 0, true}],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
        ]
      }
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "getting points for discoveries" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool: [{1, 0, false}, {1, 1, false}, {1, 2, false}, {1, 3, false}, {1, 4, false}, {1, 5, false} ]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: false } },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: false } },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: false } },
        { :space, %{ actions: [{:ocean_floor, +2, nil}], marked?: false } },
        { :space, %{ actions: [{:ocean_floor, +4, nil}], marked?: false } }
      ]
    }
    expected_state = %{ game_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:ocean_floor, +2, nil}], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [{:ocean_floor, +4, nil}], marked?: true, tracking: [{:down}] } }
      ],
      position: 6,
      score: 18,
      fish_count: 2,
      octopus_count: 2,
      resources: %{ game_state.resources |
        dice_pool: [{1, 0, true}, {1, 1, true}, {1, 2, true}, {1, 3, true}, {1, 4, true}, {1, 5, true} ]
      }
    }
    assert expected_state == Enum.reduce(0..5, game_state, fn i, acc ->
      {:ok, updated} = BathysphereLive.Backend.Game.Mechanics.down(acc, 1, i)
      updated
    end)
  end

  test "moving N removes an N die from the dice pool" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool_size: 3,
        dice_pool: [{1, 0, false}, {2, 1, false}, {6, 2, false}, {1, 3, false}, {1, 4, false}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      resources: %{ game_state.resources |
        dice_pool_size: 3,
        dice_pool: [{1, 0, true}, {2, 1, true}, {6, 2, false}, {1, 3, false}, {1, 4, true}]
      },
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false } },
      ],
      position: 4
    }
    final_state = BathysphereLive.Backend.Game.Mechanics.down(game_state, 2, 1)
    |> elem(1)
    |> BathysphereLive.Backend.Game.Mechanics.down(1, 0)
    |> elem(1)
    |> BathysphereLive.Backend.Game.Mechanics.down(1, 4)

    assert {:ok, expected_state} == final_state

  end

  test "cannot move N without N die in the dice pool" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool_size: 3,
        dice_pool: [{1, 2, false}, {3, 2, false}, {6, 2, false}]
      }
    }
    expected_state = %{ game_state |
      resources: %{ game_state.resources |
        dice_pool_size: 3,
        dice_pool: [{1, 2, false}, {3, 2, false}, {6, 2, false}]
      }
    }
    assert { :invalid_move, expected_state } == BathysphereLive.Backend.Game.Mechanics.down(game_state, 2, 0)
    assert { :invalid_move, expected_state } == BathysphereLive.Backend.Game.Mechanics.up(game_state, 4, 0)
  end

  test "initial population of the dice pool" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool_size: 3,
        dice_pool: []
      }
    }
    {:ok, updated_state} = BathysphereLive.Backend.Game.Mechanics.roll(game_state, :init)
    assert game_state.resources.dice_pool_size == Enum.count(updated_state.resources.dice_pool)
    Enum.with_index(updated_state.resources.dice_pool)
    |> Enum.each(fn {{die, index, used?}, idx} ->
      assert die <= 6 and die >= 1
      assert index == idx
      assert used? == false
    end)
  end

  test "re-population of the dice pool" do
    game_state = %{ @base_state |
      resources: %{ @base_state.resources |
        dice_pool_size: 3,
        dice_pool: [{7, 0, false}, {8, 1, false}, {9, 2, false}]
      }
    }
    { :ok, updated_state } = BathysphereLive.Backend.Game.Mechanics.roll(game_state)
    assert game_state.resources.dice_pool_size == Enum.count(updated_state.resources.dice_pool)
    assert game_state.resources.dice_pool != updated_state.resources.dice_pool
    assert [
      %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
      %BathysphereLive.Backend.Game.Resource{type: :oxygen}
    ] == updated_state.resources.oxygen
  end

  test "rerolling the dice can kill you" do
    game_state = %{ @base_state |
      resources: %{
        dice_pool_size: 3,
        dice_pool: [{1, 0, false}, {5, 1, false}, {2, 2, false}],
        stress: [],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: []
      }
    }
    expected_state = %{ game_state |
      state: :dead,
      resources: %{ game_state.resources |
        dice_pool_size: 3,
        dice_pool: [{1, 0, false}, {5, 1, false}, {2, 2, false}],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
        ]
      }
    }
    { final_state, updated_state } = BathysphereLive.Backend.Game.Mechanics.roll(game_state)
    assert {:dead, expected_state} == {
      final_state,
      %{ updated_state |
        resources: %{ updated_state.resources |
          dice_pool: [{1, 0, false}, {5, 1, false}, {2, 2, false}]
        }
      }
    }
  end

  test "moving back over a space with actions a second time" do
    game_state = %{ @base_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [{:damage, -1, false}, {:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 0,
      resources: %{
        dice_pool: [{5, 0, false}, {4, 1, false}, {5, 2, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: false},
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: false},
        ]
      }
    }

    first_state = %{ game_state |
      state: :ok,
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:oxygen, -1, true}, {:stress, -1, false}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, true}, {:oxygen, -1, false}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}, {:stress, -1, false}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 5,
      direction: 1,
      resources: %{
        dice_pool: [{5, 0, true}, {4, 1, false}, {5, 2, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: false}
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: false}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: false},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: false}
        ]
      }
    }
    assert {:ok, first_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 5, 0)
      |> elem(1)
      |> BathysphereLive.Backend.Game.Mechanics.select_action({{:oxygen, -1, false}, 0})
      |> elem(1)
      |> BathysphereLive.Backend.Game.Mechanics.select_action({{:stress, -1, false}, 0})
      |> elem(1)
      |> BathysphereLive.Backend.Game.Mechanics.select_action({{:damage, -1, false}, 0})

    second_state = %{ first_state |
      state: :ok,
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: true, tracking: [{:down},{:up}] } },
        { :space, %{ actions: [{:oxygen, -1, true}, {:stress, -1, true}], marked?: false, tracking: [{:down},{:up}] } },
        { :space, %{ actions: [{:stress, -1, true}, {:oxygen, -1, true}], marked?: false, tracking: [{:down},{:up}] } },
        { :space, %{ actions: [{:damage, -1, true}, {:stress, -1, true}], marked?: false, tracking: [{:down},{:up}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 1,
      direction: -1,
      resources: %{ game_state.resources |
        dice_pool: [{5, 0, true}, {4, 1, true}, {5, 2, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage}
        ]
      }
    }
    assert {:ok, second_state} == BathysphereLive.Backend.Game.Mechanics.up(first_state, 4, 1)
  end

  test "select action when passing a space with multiple actions" do
    game_state = %{ @base_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, false}], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 0,
      resources: %{
        dice_pool: [{6, 0, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage}
        ]
      }
    }
    select1_state = %{ game_state |
      state: {:select_action, [{{:oxygen, -1, false}, 0}, {{:stress, -1, false}, 1}]},
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, false}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 4,
      remaining: 2,
      resources: %{
        dice_pool: [{6, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage}
        ]
      }
    }
    select2_state = %{ select1_state |
      state: {:select_action, [{{:stress, -1, false}, 0}, {{:oxygen, -1, false}, 1}]},
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 5,
      remaining: 1,
      resources: %{
        dice_pool: [{6, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage}
        ]
      }
    }
    final_state = %{ select2_state |
      state: :ok,
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } }
      ],
      position: 6,
      remaining: 0,
      resources: %{
        dice_pool: [{6, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage}
        ]
      }
    }

    assert {select1_state.state, select1_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 6, 0)
    assert {select2_state.state, select2_state} == BathysphereLive.Backend.Game.Mechanics.select_action(select1_state, {{:stress, -1, false}, 1})
    assert {final_state.state, final_state} == BathysphereLive.Backend.Game.Mechanics.select_action(select2_state, {{:oxygen, -1, false}, 1})
  end

  test "triggering damage from stress" do
    game_state = %{ @base_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 0,
      resources: %{
        dice_pool: [{6, 0, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
          %BathysphereLive.Backend.Game.Resource{type: :damage}
        ]
      }
    }
    expected_state = %{ game_state |
      state: :dead,
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:stress, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } }
      ],
      position: 6,
      resources: %{
        dice_pool: [{6, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, used?: true, penalties: [:damage]},
          %BathysphereLive.Backend.Game.Resource{type: :stress, penalties: [:damage]},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen}
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true},
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true}
        ]
      }
    }
    assert {expected_state.state, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 6, 0)
  end

  test "losing dice from damage" do
    game_state = %{ @base_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 0,
      resources: %{
        dice_pool_size: 3,
        dice_pool: [{3, 0, false}, {8, 1, false}, {9, 2, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, penalties: [:dice]},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
        ]
      }
    }
    expected_state = %{ game_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false, tracking: [{:down}] } },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } }
      ],
      position: 3,
      resources: %{
        dice_pool_size: 2,
        dice_pool: [{3, 0, true}, {8, 1, false}, {9, 2, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress},
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage, used?: true, penalties: [:dice]},
          %BathysphereLive.Backend.Game.Resource{type: :damage},
        ]
      }
    }
    assert {expected_state.state, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
    {_ignore, final_state} = BathysphereLive.Backend.Game.Mechanics.roll(expected_state)
    assert 2 == Enum.count(final_state.resources.dice_pool)
  end

  test "having one of each resource is enough to be alive" do
    game_state = %{ @base_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 0,
      resources: %{
        dice_pool_size: 1,
        dice_pool: [{1, 0, false}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage},
        ]
      }
    }
    expected_state = %{ game_state |
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: true, tracking: [{:down}] } }
      ],
      position: 1,
      resources: %{
        dice_pool_size: 1,
        dice_pool: [{1, 0, true}],
        stress: [
          %BathysphereLive.Backend.Game.Resource{type: :stress},
        ],
        oxygen: [
          %BathysphereLive.Backend.Game.Resource{type: :oxygen},
        ],
        damage: [
          %BathysphereLive.Backend.Game.Resource{type: :damage},
        ]
      }
    }
    assert {expected_state.state, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 1, 0)
  end

end
