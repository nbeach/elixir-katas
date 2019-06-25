defmodule StateManager do
  def start(store_name), do: Agent.start_link(fn -> VendingMachine.new() end, name: store_name)
  def stop(store_name), do: Agent.stop(store_name)

  def wrap(operation, store_name), do: call_and_update(fn state -> operation.(state) end, store_name)
  def wrap(operation, store_name, arg1), do: call_and_update(fn state -> operation.(state, arg1) end, store_name)
  def wrap(operation, store_name, arg1, arg2), do: call_and_update(fn state -> operation.(state, arg1, arg2) end, store_name)
  def wrap(operation, store_name, arg1, arg2, arg3), do: call_and_update(fn state -> operation.(state, arg1, arg2, arg3) end, store_name)

  defp call_and_update(operation, store_name) do
    {result, new_state} = operation.(get_state(store_name))
    update_state(store_name, new_state)
    result
  end

  defp get_state(store_name) do
    Agent.get(store_name, &(&1))
  end

  defp update_state(store_name, new_state) do
    Agent.update(store_name, fn _ -> new_state end)
  end

end
