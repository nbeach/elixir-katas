defmodule HeatNode.Client do

  def get_heat_value(server) do
    GenServer.call(server, :get_heat_value)
  end

end
