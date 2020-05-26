defmodule MechanicsTest do
  use ExUnit.Case

  @base_state %BathysphereLive.Backend.Game.State{
    dice_pool_size: 1,
    dice_pool: [],
    map: [],
    state: :ok,
    position: 0,
    remaining: 0,
    direction: 1,
    score: 0,
    oxygen: [{:oxygen, false},{:oxygen, false}],
    stress: [{:stress, false},{:stress, false}],
    damage: [{:damage, false},{:damage, false}],
    fish_points: [+2, +2, +3],
    octopus_points: [+3, +5],
    fish_count: 0,
    octopus_count: 0
  }

  test "moving down onto empty space" do
    game_state = %{ @base_state |
      dice_pool: [{1, 0, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      dice_pool: [{1, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true } },
      ],
      position: 1
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 1, 0)
  end

  test "moving down onto a marked space" do
    game_state = %{ @base_state |
      dice_pool: [{1, 0, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true } },
      ]
    }
    expected_state = %{ game_state |
      dice_pool: [{1, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true } },
      ],
      position: 1,
      stress: [{:stress, true},{:stress, false}]
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 1, 0)
  end

  test "moving down and discovering an octopus" do
    game_state = %{ @base_state |
      dice_pool: [{1, 0, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      dice_pool: [{1, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: true } },
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
      dice_pool: [{1, 0, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      dice_pool: [{1, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: true } },
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
      dice_pool: [{5, 0, false}],
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
      dice_pool: [{5, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:oxygen, -1, false}], marked?: true } },
        { :space, %{ actions: [{:stress, -1, true}], marked?: true } },
        { :space, %{ actions: [{:damage, -2, true}], marked?: true } },
        { :space, %{ actions: [{:stress, -1, false}], marked?: true } },
        { :space, %{ actions: [], marked?: true } },
      ],
      position: 5
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 5, 0)
  end

  test "moving down past depth_zone" do
    game_state = %{ @base_state |
      dice_pool: [{3, 0, false}],
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
      dice_pool: [{3, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: true } },
        { :space, %{ actions: [], marked?: false } },
      ],
      position: 4,
      stress: [{:stress, true},{:stress, true}]
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "moving down past the bottom" do
    game_state = %{ @base_state |
      dice_pool: [{3, 0, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      dice_pool: [{3, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: true } },
      ],
      position: 2,
      stress: [{:stress, true},{:stress, false}]
    }
    assert {:ok, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "completing the game" do
    game_state = %{ @base_state |
      dice_pool: [{3, 0, false}],
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
      dice_pool: [{3, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
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
      dice_pool: [{3, 0, false}],
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
      dice_pool: [{3, 0, true}],
      map: [
        { :start, %{} },
        { :depth_zone, %{} },
        { :space, %{ actions: [{:stress, -1, true}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :depth_zone, %{} },
        { :space, %{ actions: [], marked?: true } },
      ],
      position: 5,
      stress: [{:stress, true},{:stress, true}]
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "running out of damage" do
    game_state = %{ @base_state |
      dice_pool: [{4, 0, false}],
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
      dice_pool: [{4, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [], marked?: true } },
      ],
      position: 4,
      damage: [{:damage, true},{:damage, true}]
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 4, 0)
  end

  test "running out of oxygen" do
    game_state = %{ @base_state |
      dice_pool: [{3, 0, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:oxygen, -2, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
      ]
    }
    expected_state = %{ game_state |
      state: :dead,
      dice_pool: [{3, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:oxygen, -2, true}], marked?: false } },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: true } },
      ],
      position: 3,
      oxygen: [{:oxygen, true},{:oxygen, true}]
    }
    assert {:dead, expected_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 3, 0)
  end

  test "getting points for discoveries" do
    game_state = %{ @base_state |
      dice_pool: [{1, 0, false}, {1, 1, false}, {1, 2, false}, {1, 3, false}, {1, 4, false}, {1, 5, false} ],
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
      dice_pool: [{1, 0, true}, {1, 1, true}, {1, 2, true}, {1, 3, true}, {1, 4, true}, {1, 5, true} ],
      map: [
        { :start, %{} },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: true } },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: true } },
        { :space, %{ actions: [{:discovery, :fish, nil}], marked?: true } },
        { :space, %{ actions: [{:discovery, :octopus, nil}], marked?: true } },
        { :space, %{ actions: [{:ocean_floor, +2, nil}], marked?: true } },
        { :space, %{ actions: [{:ocean_floor, +4, nil}], marked?: true } }
      ],
      position: 6,
      score: 18,
      fish_count: 2,
      octopus_count: 2
    }
    assert expected_state == Enum.reduce(0..5, game_state, fn i, acc ->
      {:ok, updated} = BathysphereLive.Backend.Game.Mechanics.down(acc, 1, i)
      updated
    end)
  end

  test "moving N removes an N die from the dice pool" do
    game_state = %{ @base_state |
      dice_pool_size: 3,
      dice_pool: [{1, 0, false}, {2, 1, false}, {6, 2, false}, {1, 3, false}, {1, 4, false}],
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
      dice_pool_size: 3,
      dice_pool: [{1, 0, true}, {2, 1, true}, {6, 2, false}, {1, 3, false}, {1, 4, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [], marked?: true } },
        { :space, %{ actions: [], marked?: true } },
        { :space, %{ actions: [], marked?: true } },
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
      dice_pool_size: 3,
      dice_pool: [{1, 2, false}, {3, 2, false}, {6, 2, false}]
    }
    expected_state = %{ game_state |
      dice_pool_size: 3,
      dice_pool: [{1, 2, false}, {3, 2, false}, {6, 2, false}]
    }
    assert { :invalid_move, expected_state } == BathysphereLive.Backend.Game.Mechanics.down(game_state, 2, 0)
    assert { :invalid_move, expected_state } == BathysphereLive.Backend.Game.Mechanics.up(game_state, 4, 0)
  end

  test "initial population of the dice pool" do
    game_state = %{ @base_state |
      dice_pool_size: 3,
      dice_pool: []
    }
    {:ok, updated_state} = BathysphereLive.Backend.Game.Mechanics.roll(game_state, :init)
    assert game_state.dice_pool_size == Enum.count(updated_state.dice_pool)
    Enum.with_index(updated_state.dice_pool)
    |> Enum.each(fn {{die, index, used?}, idx} ->
      assert die <= 6 and die >= 1
      assert index == idx
      assert used? == false
    end)
  end

  test "re-population of the dice pool" do
    game_state = %{ @base_state |
      dice_pool_size: 3,
      dice_pool: [{7, 0, false}, {8, 1, false}, {9, 2, false}],
      oxygen: [{:oxygen, false},{:oxygen, false}]
    }
    { :ok, updated_state } = BathysphereLive.Backend.Game.Mechanics.roll(game_state)
    assert game_state.dice_pool_size == Enum.count(updated_state.dice_pool)
    assert game_state.dice_pool != updated_state.dice_pool
    assert [{:oxygen, true},{:oxygen, false}] = updated_state.oxygen
  end

  test "rerolling the dice can kill you" do
    game_state = %{ @base_state |
      dice_pool_size: 3,
      dice_pool: [{1, 0, false}, {5, 1, false}, {2, 2, false}],
      oxygen: [{:oxygen, true},{:oxygen, false}]
    }
    expected_state = %{ game_state |
      state: :dead,
      dice_pool_size: 3,
      dice_pool: [{1, 0, false}, {5, 1, false}, {2, 2, false}],
      oxygen: [{:oxygen, true},{:oxygen, true}]
    }
    { final_state, updated_state } = BathysphereLive.Backend.Game.Mechanics.roll(game_state)
    assert {:dead, expected_state} == {
      final_state,
      %{ updated_state | dice_pool: [{1, 0, false}, {5, 1, false}, {2, 2, false}] } }
  end

  test "moving back over a space with actions a second time" do
    game_state = %{ @base_state |
      dice_pool: [{5, 0, false}, {4, 1, false}, {5, 2, false}],
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
      stress: [{:stress, false},{:stress, false},{:stress, false},{:stress, false}],
      oxygen: [{:oxygen, false},{:oxygen, false},{:oxygen, false},{:oxygen, false}],
      damage: [{:damage, false},{:damage, false},{:damage, false},{:damage, false}]
    }

    first_state = %{ game_state |
      state: :ok,
      dice_pool: [{5, 0, true}, {4, 1, false}, {5, 2, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:oxygen, -1, true}, {:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, true}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}, {:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: true } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 5,
      direction: 1,
      stress: [{:stress, true},{:stress, false},{:stress, false},{:stress, false}],
      oxygen: [{:oxygen, true},{:oxygen, false},{:oxygen, false},{:oxygen, false}],
      damage: [{:damage, true},{:damage, false},{:damage, false},{:damage, false}]
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
      dice_pool: [{5, 0, true}, {4, 1, true}, {5, 2, false}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: true } },
        { :space, %{ actions: [{:oxygen, -1, true}, {:stress, -1, true}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, true}, {:oxygen, -1, true}], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}, {:stress, -1, true}], marked?: false } },
        { :space, %{ actions: [], marked?: true } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 1,
      direction: -1,
      stress: [{:stress, true},{:stress, true},{:stress, true},{:stress, false}],
      oxygen: [{:oxygen, true},{:oxygen, true},{:oxygen, false},{:oxygen, false}],
      damage: [{:damage, true},{:damage, false},{:damage, false},{:damage, false}]
    }
    assert {:ok, second_state} == BathysphereLive.Backend.Game.Mechanics.up(first_state, 4, 1)
  end

  test "select action when passing a space with multiple actions" do
    game_state = %{ @base_state |
      dice_pool: [{6, 0, false}],
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
      stress: [{:stress, false},{:stress, false},{:stress, false},{:stress, false}],
      oxygen: [{:oxygen, false},{:oxygen, false},{:oxygen, false},{:oxygen, false}],
      damage: [{:damage, false},{:damage, false},{:damage, false},{:damage, false}]
    }
    select1_state = %{ game_state |
      state: {:select_action, [{{:oxygen, -1, false}, 0}, {{:stress, -1, false}, 1}]},
      dice_pool: [{6, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, false}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 4,
      remaining: 2,
      stress: [{:stress, false},{:stress, false},{:stress, false},{:stress, false}],
      oxygen: [{:oxygen, false},{:oxygen, false},{:oxygen, false},{:oxygen, false}],
      damage: [{:damage, true},{:damage, false},{:damage, false},{:damage, false}]
    }
    select2_state = %{ select1_state |
      state: {:select_action, [{{:stress, -1, false}, 0}, {{:oxygen, -1, false}, 1}]},
      dice_pool: [{6, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, true}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, false}], marked?: false } },
        { :space, %{ actions: [], marked?: false } }
      ],
      position: 5,
      remaining: 1,
      stress: [{:stress, true},{:stress, false},{:stress, false},{:stress, false}],
      oxygen: [{:oxygen, false},{:oxygen, false},{:oxygen, false},{:oxygen, false}],
      damage: [{:damage, true},{:damage, false},{:damage, false},{:damage, false}]
    }
    final_state = %{ select2_state |
      state: :ok,
      dice_pool: [{6, 0, true}],
      map: [
        { :start, %{} },
        { :space, %{ actions: [], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [{:damage, -1, true}], marked?: false } },
        { :space, %{ actions: [{:oxygen, -1, false}, {:stress, -1, true}], marked?: false } },
        { :space, %{ actions: [{:stress, -1, false}, {:oxygen, -1, true}], marked?: false } },
        { :space, %{ actions: [], marked?: true } }
      ],
      position: 6,
      remaining: 0,
      stress: [{:stress, true},{:stress, false},{:stress, false},{:stress, false}],
      oxygen: [{:oxygen, true},{:oxygen, false},{:oxygen, false},{:oxygen, false}],
      damage: [{:damage, true},{:damage, false},{:damage, false},{:damage, false}]
    }

    assert {select1_state.state, select1_state} == BathysphereLive.Backend.Game.Mechanics.down(game_state, 6, 0)
    assert {select2_state.state, select2_state} == BathysphereLive.Backend.Game.Mechanics.select_action(select1_state, {{:stress, -1, false}, 1})
    assert {final_state.state, final_state} == BathysphereLive.Backend.Game.Mechanics.select_action(select2_state, {{:oxygen, -1, false}, 1})
  end

  test "triggering damage from stress" do
  end

  test "losing dice from oxygen" do
  end

end
