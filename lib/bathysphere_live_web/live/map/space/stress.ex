defmodule BathysphereLiveWeb.Map.Space.Stress do
  use Phoenix.LiveComponent

  def render(%{used?: true} = assigns) do
    ~L"""
    """
  end
  def render(assigns) do
    ~L"""
      <span
        class=""
        has-tooltip-multiline
        data-tooltip="Stress: <%= @value %>"
      >
        <i class="fas fa-exclamation-circle"></i>
        <%= @value %>
      </span>
    """
  end
end
