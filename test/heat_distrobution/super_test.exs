defmodule HeatDistributionSupervisorTest do
  use ExUnit.Case
  doctest HeatDistribution.Supervisor

  describe "when given a" do
    test "number returns the number" do
      assert HeatNode.Client.get_heat_value(HeatDistribution.Supervisor.registry_reference([ x: 0, y: 0 ])) == 1
      assert HeatNode.Client.get_heat_value(HeatDistribution.Supervisor.registry_reference([ x: 1, y: 1 ])) == 5
      assert HeatNode.Client.get_heat_value(HeatDistribution.Supervisor.registry_reference([ x: 2, y: 2 ])) == 9
    end

  end
end
