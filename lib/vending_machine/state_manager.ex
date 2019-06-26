defmodule StateManager do
  defmacro __using__(opts) do
    store_name = Keyword.get(opts, :store_name)
    initial_state = Keyword.get(opts, :initial_state)

    [{name, arity} | _] = VendingMachine.__info__(:functions)
    |> Keyword.to_list()

#    IO.inspect(functions)


    quote do
      def start(), do: Agent.start_link(fn -> unquote(initial_state) end, name: unquote(store_name))
      def stop(), do: Agent.stop(unquote(store_name))

      def wrap(operation), do: update_state_with(unquote(store_name), fn state -> operation.(state) end)
      def wrap(operation, arg1), do: update_state_with(unquote(store_name), fn state -> operation.(state, arg1) end)
      def wrap(operation, arg1, arg2), do: update_state_with(unquote(store_name), fn state -> operation.(state, arg1, arg2) end)
      def wrap(operation, arg1, arg2, arg3), do: update_state_with(unquote(store_name), fn state -> operation.(state, arg1, arg2, arg3) end)

      defp update_state_with(store_name, operation) do
        prior_state = get_state(store_name)
        {result, new_state} = operation.(prior_state)
        update_state(store_name, new_state)
        result
      end

      defp get_state(store_name) do
        Agent.get(store_name, &(&1))
      end

      defp update_state(store_name, new_state) do
        Agent.update(store_name, fn _ -> new_state end)
      end


      def unquote(name)() do
        apply(VendingMachine, unquote(name), [get_state(unquote(store_name))])
      end
    end
  end



end
