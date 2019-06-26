defmodule VendingMachineApplication do
  use StateManager,
      module: VendingMachine,
      store_name: __MODULE__,
      initial_state: VendingMachine.new()
end
