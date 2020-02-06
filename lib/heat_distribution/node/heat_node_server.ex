defmodule HeatNode.Server do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, Keyword.get(opts, :state), opts)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_heat_value, _from, state) do
    {:reply, state, state}
  end

end
