defmodule BathysphereLiveWeb.Map.Space.Stress do
  use Phoenix.LiveComponent

  def render(%{used?: true} = assigns) do
    ~L"""
    """
  end
  def render(assigns) do
    ~L"""
      <span
        class="is-size-3"
        has-tooltip-multiline
        data-tooltip="Stress: <%= @value %>"
      >
        <i class="fas fa-exclamation-circle"></i>
        <%= @value %>
      </span>
    """
  end
end
