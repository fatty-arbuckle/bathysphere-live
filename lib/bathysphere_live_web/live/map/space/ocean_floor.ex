defmodule BathysphereLiveWeb.Map.Space.OceanFloor do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class=""
      has-tooltip-multiline
      data-tooltip="Ocean Floor: <%= pretty_value(@value) %>"
    >
      <i class="fas fa-anchor"></i>
      <%= pretty_value(@value) %>
    </span>
    """
  end

  defp pretty_value(value) when value > 0, do: "+#{value}"
  defp pretty_value(value), do: value
end
