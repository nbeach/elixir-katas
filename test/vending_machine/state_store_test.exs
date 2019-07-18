defmodule StateStoreTest do
  use ExUnit.Case, async: true

  test "wraps a modules methods with state" do
    defmodule Foo do
      def new() do
        %{value: 5}
      end

      def multiply(state, number) do
        multiplied = state.value * number
        {multiplied, Map.put(state, :value, multiplied)}
      end

      def get_value(state) do
        {state.value, state}
      end
    end

    defmodule StatefulFoo do
      use StateStore,
        module: StateStoreTest.Foo,
        store_name: __MODULE__,
        initial_state: Foo.new()
    end

    StatefulFoo.start()
    doubled = StatefulFoo.multiply(2)
    changed_value = StatefulFoo.get_value()
    StatefulFoo.stop()

    assert doubled == 10
    assert changed_value == 10
  end
end
