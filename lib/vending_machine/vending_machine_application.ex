defmodule VendingMachineApplication do
  use StateStore,
      module: VendingMachine,
      store_name: __MODULE__,
      initial_state: %VendingMachine{
        inventory: [
          %{ product: %{ name: "Cola", price: 100 }, quantity: 1 },
          %{ product: %{ name: "Chips", price: 50 }, quantity: 1 },
          %{ product: %{ name: "Candy", price: 65 }, quantity: 1 }
        ]
      }
end
