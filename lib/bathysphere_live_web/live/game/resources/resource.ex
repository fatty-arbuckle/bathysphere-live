defmodule BathysphereLiveWeb.Game.Resources.Resource do
  use Phoenix.LiveComponent

  # @size,    size of the resource
  # @used?,   draw the resource as used or unused
  # @value,   amount of the resource, nil draws no value
  # @type,  the type of resource to draw
  def render(assigns) do
    ~L"""
    <span
      class="<%= @size %> <%= text_color(@used?) %>"
      has-tooltip-multiline
      data-tooltip="<%= label(@type) %> <%= if @value != nil, do: ": #{@value}" %>"
    >
      <i class="fas <%= icon(@type) %>"></i>
      <%= if @value != nil do
        @value
      end %>
    </span>
    """
  end

  defp icon(:stress), do: "fa-exclamation-circle"
  defp icon(:damage), do: "fa-skull"
  defp icon(:oxygen), do: "fa-soap"

  defp label(type) do
    Atom.to_string(type)
    |> String.capitalize
  end

  defp text_color(nil), do: "has-text-success"
  defp text_color(false), do: "has-text-danger"
  defp text_color(true), do: "has-text-gray"

end
