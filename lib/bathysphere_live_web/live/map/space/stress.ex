defmodule BathysphereLiveWeb.Map.Space.Stress do
  use Phoenix.LiveComponent

  def render(%{used?: true} = assigns) do
    ~L"""
    """
  end
  def render(assigns) do
    ~L"""
      <span>STRESS <%= @value %></span>
    """
  end
end
