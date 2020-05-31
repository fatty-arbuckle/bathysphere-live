defmodule BathysphereLiveWeb.Game.Map.Space.Resource do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <span
      class="<%= @size %> <%= text_color(@used?) %>"
      has-tooltip-multiline
      data-tooltip="<%= label(@resource) %> <%= if @value != nil, do: ": #{@value}" %>"
    >
      <i class="fas <%= icon(@resource) %>"></i>
      <%= if @value != nil do
        @value
      end %>
    </span>
    """
  end

  defp icon(:stress), do: "fa-exclamation-circle"
  defp icon(:damage), do: "fa-skull"
  defp icon(:oxygen), do: "fa-soap"

  defp label(resource) do
    Atom.to_string(resource)
    |> String.capitalize
  end

  defp text_color(nil), do: "has-text-success"
  defp text_color(false), do: "has-text-danger"
  defp text_color(true), do: "has-text-gray"

end
