defmodule VendingMachineApplication do
  @store_name :vending_machine

  def start(), do: StateManager.start(@store_name)
  def stop(), do: StateManager.stop(@store_name)

  def display(), do: StateManager.wrap(&VendingMachine.display/1, @store_name)
  def insert_coin(coin), do: StateManager.wrap(&VendingMachine.insert_coin/2, @store_name, coin)
  def empty_coin_return(), do: StateManager.wrap(&VendingMachine.empty_coin_return/1, @store_name)
end
