
defmodule BathysphereLive.Backend.Library.Games do

  @games %{
    BathysphereLive.Backend.Library.Game0c.name => BathysphereLive.Backend.Library.Game0c.game
  }

  def list() do
    Map.keys(@games)
  end


  def load(name) do
    @games[name]
  end

end
