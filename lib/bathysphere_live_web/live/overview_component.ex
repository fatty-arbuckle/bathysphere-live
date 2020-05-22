defmodule BathysphereLiveWeb.OverviewComponent do
  use Phoenix.LiveComponent


  # def update(
  #   %{
  #     state: state,
  #     dice_pool_size: dice_pool_size,
  #     dice_pool: dice_pool,
  #     score: score,
  #     fish_points: fish_points, octopus_points: octopus_points} = _assigns, socket) do
  #   { :ok, assign(socket, state: state, dice_pool_size: dice_pool_size, dice_pool: dice_pool, score: score, fish_points: fish_points, octopus_points: octopus_points) }
  # end

  def render(assigns) do
    ~L"""
      <div class="box has-background-grey-lighter">
        <%= for value <- @dice_pool do %>
          <span class="is-size-1 has-text-success">
            <i class="fas <%= die(value) %>"></i>
          </span>
        <% end %>

        <%= for _value <- 0..(@dice_pool_size - Enum.count(@dice_pool) - 1) do %>
          <span class="is-size-1">
            <i class="fas fa-square"></i>
          </span>
        <% end %>
      </div>

      <div class="box has-background-grey-lighter has-text-left">
        <span class="is-size-3 has-text-info">
          Score:
        </span>
        <span class="is-size-3">
         <%= @score %>
        </span>
      </div>

      <div class="box has-text-left has-background-grey-lighter">
        <span class="is-size-3 has-text-info">
          <i class="fas fa-fish"></i>
        </span>
        <%= for {value, idx} <- Enum.with_index(@fish_points) do %>
          <span class="is-size-3 <%= if idx < @fish_count, do: "has-text-success", else: "" %>">
            <%= pretty_value(value) %>
          </span>
        <% end %>
      </div>

      <div class="box has-text-left has-background-grey-lighter">
        <span class="is-size-3 has-text-info">
          <i class="fas fa-wind"></i>
        </span>
        <%= for {value, idx} <- Enum.with_index(@octopus_points) do %>
        <span class="is-size-3 <%= if idx < @octopus_count, do: "has-text-success", else: "" %>">
            <%= pretty_value(value) %>
          </span>
        <% end %>
      </div>

      <%= live_component(@socket, BathysphereLiveWeb.Map.Overview.Resource, resource: @oxygen, label: "Oxygen", icon: "fa-soap") %>
      <%= live_component(@socket, BathysphereLiveWeb.Map.Overview.Resource, resource: @stress, label: "Stress", icon: "fa-exclamation-circle") %>
      <%= live_component(@socket, BathysphereLiveWeb.Map.Overview.Resource, resource: @damage, label: "Damage", icon: "fa-ambulance") %>

    """
  end

  defp die(1), do: "fa-dice-one"
  defp die(2), do: "fa-dice-two"
  defp die(3), do: "fa-dice-three"
  defp die(4), do: "fa-dice-four"
  defp die(5), do: "fa-dice-five"
  defp die(6), do: "fa-dice-six"

  defp pretty_value(value) when value > 0, do: "+#{value}"
  defp pretty_value(value), do: value


end
