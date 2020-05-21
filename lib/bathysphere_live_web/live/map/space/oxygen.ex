defmodule BathysphereLiveWeb.Map.Space.Oxygen do
  use Phoenix.LiveComponent

  def render(%{used?: true} = assigns) do
    ~L"""
    """
  end
  def render(assigns) do
    ~L"""
      <span>OXYGEN <%= @value %></span>
    """
  end
end
