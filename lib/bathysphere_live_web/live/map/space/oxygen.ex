defmodule BathysphereLiveWeb.Map.Space.Oxygen do
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
      data-tooltip="Oxygen: <%= @value %>"
    >
      <i class="fas fa-soap"></i>
      <%= @value %>
    </span>
    """
  end
end
