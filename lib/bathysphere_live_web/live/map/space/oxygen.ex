defmodule BathysphereLiveWeb.Map.Space.Oxygen do
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
      data-tooltip="Oxygen: <%= @value %>"
    >
      <i class="fas fa-soap"></i>
      <%= @value %>
    </span>
    """
  end
end
