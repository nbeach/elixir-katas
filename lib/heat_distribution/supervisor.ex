defmodule HeatDistribution.Supervisor do
  use Supervisor
  import Enum

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, _} = Registry.start_link(keys: :unique, name: :heat_registry)

    initial_grid_state = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]

    nodes = map(initial_grid_state, &with_index/1)
    |> with_index()
    |> flat_map(fn {node, y_cord} -> map(node, fn {value, x_cord} -> %{ x: x_cord, y: y_cord, value: value} end) end)

    children = map(nodes, fn node ->
      %{
        id:  "#{node.x}x#{node.y}",
        start: { HeatNode.Server, :start_link, [[name: registry_reference([x: node.x, y: node.y]), state: node.value]]}
      }
    end)


    Supervisor.init(children, strategy: :one_for_one)
  end

  def registry_reference(key) do
    {:via, Registry, {:heat_registry, key}}
  end

end

