defmodule BathysphereLive.Backend.Game.Mechanics do

  def roll(game_state, :init) do
    new_state = update_dice_pool(game_state, roll_dice(game_state.resources.dice_pool_size))
    { new_state.state, new_state }
  end
  def roll(game_state) do
    new_state = game_state
    |> update_dice_pool(roll_dice(game_state.resources.dice_pool_size))
    new_state = Map.put(new_state, :resources, mark_resource(:oxygen, new_state.resources, 1))
    |> evaluate_game
    { new_state.state, new_state }
  end

  def select_action(game_state, {{type, value, _used?} = action, _idx}) do
    { :space, %{ actions: actions } = data } = Enum.at(game_state.map, game_state.position)
    action_idx = Enum.find_index(actions, fn a ->
      action == a
    end)
    updated_actions = List.replace_at(actions, action_idx, {type, value, true})
    updated_space = { :space, %{ data | actions: updated_actions } }
    updated_game_state = %{ game_state |
      state: :ok,
      map: List.replace_at(game_state.map, game_state.position, updated_space)
    }
    updated_game_state = %{ updated_game_state | resources: mark_resource(type, updated_game_state.resources, abs(value)) }
    updated_game_state = move(updated_game_state)
    {updated_game_state.state, updated_game_state}
  end

  def up(%{state: :ok, resources: %{ dice_pool: dice_pool } } = game_state, n, index) do
    {die, _idx, used?} = Enum.at(dice_pool, index)
    cond do
      die != n ->
        {:invalid_move, game_state}
      used? ->
        {:invalid_move, game_state}
      !used? ->
        updated = move(%{ game_state | remaining: n, direction: -1 })
        { updated.state, update_dice_pool(updated, List.replace_at(dice_pool, index, {die, index, true})) }
    end
  end
  def up(%{state: state} = game_state, _n, _index), do: {state, game_state}

  def down(%{state: :ok, resources: %{ dice_pool: dice_pool } } = game_state, n, index) do
    {die, _idx, used?} = Enum.at(dice_pool, index)
    cond do
      die != n ->
        {:invalid_move, game_state}
      used? ->
        {:invalid_move, game_state}
      !used? ->
        updated = move(%{ game_state | remaining: n, direction: +1 })
        {updated.state, update_dice_pool(updated, List.replace_at(dice_pool, index, {die, index, true}))}
    end
  end
  def down(%{state: state} = game_state, _n, _index), do: {state, game_state}


  defp roll_dice(n) do
    Enum.map(0..(n-1), fn idx ->
      { :rand.uniform(6), idx, false }
    end)
  end

  # returns a game_state with the dice_pool updated
  defp update_dice_pool(game_state, new_dice_pool) do
    %{ game_state |
      resources: Map.put(game_state.resources, :dice_pool, new_dice_pool)
    }
  end

  defp move(%{ remaining: 0 } = game_state) do
    game_state
  end
  defp move(%{state: {:select_action, _actions}} = game_state) do
    game_state
  end
  defp move(%{ remaining: remaining } = game_state) do
    case update_position(game_state) do
      {:out_of_bounds, position} ->
        # TODO apply penalty for out_of_bounds?
        {:space, data} = Enum.at(game_state.map, position)
        updated_space = {:space, %{ data | marked?: true }}
        updated_map = List.replace_at(game_state.map, position, updated_space)
        %{ game_state |
          map: updated_map,
          position: position,
          remaining: 0,
          resources: mark_resource(:stress, game_state.resources, remaining)
        }
      {:ok, new_position} ->
        game_state = %{ game_state |
          position: new_position ,
          remaining: remaining - 1
        }
        game_state = evaluate(game_state)
        move(game_state)
    end
  end

  defp update_position(game_state) do
    bottom = Enum.count(game_state.map)
    if game_state.position + game_state.direction >= bottom or game_state.position + game_state.direction < 0 do
      {:out_of_bounds, game_state.position}
    else
      {:ok, game_state.position + game_state.direction}
    end
  end

  defp evaluate(game_state) do
    evaluate_space(
      Enum.at(game_state.map, game_state.position),
      game_state
    )
    |> evaluate_game
  end

  defp evaluate_space({:depth_zone, _}, %{ remaining: remaining } = game_state) do
    game_state = %{ game_state | resources: mark_resource(:stress, game_state.resources, abs(remaining + 1)) }
    # TODO special handling for depth_zone as bottom or top
    game_state = %{ game_state | remaining: remaining + 1 }
    move(game_state)
  end
  # landing on a marked space
  defp evaluate_space({:space, %{marked?: true}}, %{ remaining: 0 } = game_state) do
    %{ game_state | resources: mark_resource(:stress, game_state.resources, 1) }
    |> track_space(:landing_on_marked)
  end
  # passing over a marked space
  defp evaluate_space({:space, %{marked?: true}}, game_state) do
    game_state
    |> track_space(:passing_marked)
  end
  # landing on an unmarked space
  defp evaluate_space({:space, %{actions: _actions} = data}, %{ remaining: 0 } = game_state) do
    updated_space = {:space, %{ data | marked?: true }}
    updated_map = List.replace_at(game_state.map, game_state.position, updated_space)
    %{ game_state |
      map: updated_map
    }
    |> track_space(:landing_on_unmarked)
  end
  # passing over an unmarked space
  defp evaluate_space({:space, %{actions: actions}}, game_state) do
    actions_remaining = Enum.with_index(actions)
    |> Enum.filter(fn {{type, _data, used?}, _idx} ->
      !used? and Enum.member?([:stress, :damage, :oxygen], type)
    end)
    apply_action(game_state, actions_remaining)
    |> track_space(:passing_unmarked)
  end
  # passing by / landing on start (which is the finish)
  defp evaluate_space({:start, _}, game_state) do
    %{ game_state | state: :complete }
  end

  defp track_space(game_state, _ignore), do: update_tracking(game_state)

  defp update_tracking(game_state) do
    {:space, space_data} = Enum.at(game_state.map, game_state.position)
    updated_space = if Map.has_key?(space_data, :tracking) do
      updated_tracking = space_data.tracking ++ [{get_direction(game_state.direction)}]
      {:space, %{ space_data | tracking: updated_tracking }}
    else
      {:space, Map.put(space_data, :tracking, [{get_direction(game_state.direction)}])}
    end
    updated_map = List.replace_at(game_state.map, game_state.position, updated_space)
    %{ game_state | map: updated_map }
  end

  defp get_direction(-1), do: :up
  defp get_direction(1), do: :down
  defp get_direction(_), do: :unknown


  defp apply_action(game_state, nil), do: game_state
  defp apply_action(game_state, []), do: game_state
  defp apply_action(game_state, [ {{type, data, false}, idx} ]) do
    game_state = %{ game_state | resources: mark_resource(type, game_state.resources, abs(data)) }
    {:space, space_data} = Enum.at(game_state.map, game_state.position)
    updated_actions = List.replace_at(space_data.actions, idx, {type, data, true})
    updated_space = {:space, %{ space_data | actions: updated_actions }}
    updated_map = List.replace_at(game_state.map, game_state.position, updated_space)
    %{ game_state | map: updated_map }
  end
  defp apply_action(game_state, actions) when is_list(actions) do
    %{ game_state |
      state: { :select_action, actions }
    }
  end

  defp mark_resource(_type, resources, 0), do: resources
  defp mark_resource(:stress, resources, data) do
    { penalties, updated_resource } = replace_resource(resources.stress)
    resources = %{ resources | stress: updated_resource }
    resources = enforce_penalties(penalties, resources)
    mark_resource(:stress, resources, data - 1)
  end
  defp mark_resource(:damage, resources, data) do
    { penalties, updated_resource } = replace_resource(resources.damage)
    resources = %{ resources | damage: updated_resource }
    resources = enforce_penalties(penalties, resources)
    mark_resource(:damage, resources, data - 1)
  end
  defp mark_resource(:oxygen, resources, data) do
    { penalties, updated_resource } = replace_resource(resources.oxygen)
    resources = %{ resources | oxygen: updated_resource }
    resources = enforce_penalties(penalties, resources)
    mark_resource(:oxygen, resources, data - 1)
  end
  defp mark_resource(:dice, resources, _data) do
    %{ resources |
      dice_pool_size: resources.dice_pool_size - 1
    }
  end

  defp replace_resource(resource) do
    case Enum.find_index(resource, fn %{used?: used?} -> used? == false  end) do
      nil ->
        { [], resource }
      next_index ->
        %{penalties: penalties} = Enum.at(resource, next_index)
        {
          penalties,
          List.replace_at(resource, next_index, %{ Enum.at(resource, next_index) | used?: true })
        }
    end
  end

  defp enforce_penalties(penalties, resources) do
    Enum.reduce(penalties, resources, fn type, acc ->
      mark_resource(type, acc, 1)
    end)
  end



  defp evaluate_game(game_state) do
    game_state
    |> evaluate_resource(:stress)
    |> evaluate_resource(:damage)
    |> evaluate_resource(:oxygen)
    |> evaluate_points
    # TODO trigger actions based on state, like fewer dice or damage from stress
  end

  defp evaluate_resource(game_state, resource) do
    case Enum.any?(get_resource(game_state, resource), fn %BathysphereLive.Backend.Game.Resource{used?: used?} -> !used? end) do
      false ->
        %{ game_state | state: :dead }
      true ->
        game_state
    end
  end

  defp get_resource(game_state, :stress), do: game_state.resources.stress
  defp get_resource(game_state, :damage), do: game_state.resources.damage
  defp get_resource(game_state, :oxygen), do: game_state.resources.oxygen

  defp evaluate_points(game_state) do
    {fish, octopus, points} = Enum.reduce(game_state.map, {0, 0, 0}, fn {space_type, data}, {fish, octopus, points} ->
      case space_type do
        :space ->
          case data.marked? do
            true ->
              f = Enum.filter(data.actions, fn {type, value, _used} ->
                type == :discovery and value == :fish
              end)
              |> Enum.count
              o = Enum.filter(data.actions, fn {type, value, _used} ->
                type == :discovery and value == :octopus
              end)
              |> Enum.count
              p = Enum.reduce(data.actions, 0, fn {type, value, _used}, acc ->
                if type == :ocean_floor, do: acc + value, else: acc
              end)
              {fish + f, octopus + o, points + p}
            _ ->
              {fish, octopus, points}
          end
        _ ->
          {fish, octopus, points}
      end
    end)

    # {fish, octopus, points}
    score = [
      Enum.take(game_state.fish_points, fish) |> Enum.sum(),
      Enum.take(game_state.octopus_points, octopus) |> Enum.sum(),
      points
    ]
    |> Enum.sum

    %{ game_state |
      score: score,
      fish_count: fish,
      octopus_count: octopus,
    }
  end
end
