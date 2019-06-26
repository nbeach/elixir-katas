defmodule StateManager do

  defmacro __using__(opts) do
    store_name = Keyword.get(opts, :store_name)
    initial_state = Keyword.get(opts, :initial_state)
    module_to_wrap = Macro.expand(Keyword.get(opts, :module), __ENV__)

    lifecycle_functions = quote do
      def start(), do: Agent.start_link(fn -> unquote(initial_state) end, name: unquote(store_name))
      def stop(), do: Agent.stop(unquote(store_name))
    end

    [lifecycle_functions] ++ wrap_module_functions_with_state(module_to_wrap, store_name)
  end

  defp wrap_module_functions_with_state(module, store_name) do
    module.__info__(:functions)
    |> Keyword.to_list()
    |> Enum.filter(fn {_, arity} -> arity !== 0 end)
    |> Enum.map(&(wrap_function_with_state(module, store_name, &1)))
  end

  defp wrap_function_with_state(module, store_name, {name, arity}) do
    arguments = generate_arguments(arity - 1)

    quote do
      def unquote(name)(unquote_splicing(arguments)) do
        state = Agent.get(unquote(store_name), &(&1))
        {result, new_state} = apply(unquote(module), unquote(name), [state, unquote_splicing(arguments)])
        unless new_state === state, do: Agent.update(unquote(store_name), fn _ -> new_state end)
        result
      end
    end
  end

  defp generate_arguments(arity) do
    case arity do
      0 -> []
      _ -> Enum.map(1..arity, &generate_argument/1)
    end
  end

  defp generate_argument(number) do
    Macro.var(:"arg#{number}", __MODULE__)
  end

end
