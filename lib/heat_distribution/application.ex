defmodule HeatDistribution.Application do
  use Application

  @impl true
  def start(_type, _args) do
    HeatDistribution.Supervisor.start_link(name: HeatDistribution.Supervisor)
  end
end
