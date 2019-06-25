defmodule VendingMachineApplication do
  use StateManager, store_name: __MODULE__, initial_state: VendingMachine.new()

  def display(), do: wrap(&VendingMachine.display/1)
  def insert_coin(coin), do: wrap(&VendingMachine.insert_coin/2, coin)
  def empty_coin_return(), do: wrap(&VendingMachine.empty_coin_return/1)
end
