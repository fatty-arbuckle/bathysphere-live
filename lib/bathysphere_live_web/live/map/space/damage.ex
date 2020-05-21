defmodule BathysphereLiveWeb.Map.Space.Damage do
  use Phoenix.LiveComponent

  def render(%{used?: true} = assigns) do
    ~L"""
    """
  end
  def render(assigns) do
    ~L"""
      <span>DAMAGE <%= @value %></span>
    """
  end
end
