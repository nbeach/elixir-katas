defmodule VendingMachineClient do

  def display(server) do
    GenServer.call(server, :display)
  end

  def insert_coin(server, coin) do
    GenServer.call(server, {:insert_coin, coin})
  end

  def empty_coin_return(server) do
    GenServer.call(server, :empty_coin_return)
  end

  def list_products(server) do
    GenServer.call(server, :list_products)
  end

  def return_coins(server) do
    GenServer.cast(server, :return_coins)
  end

  def dispense(server, product_name) do
    GenServer.call(server, {:dispense, product_name})
  end

  def initialize_state(server, state) do
    GenServer.cast(server, {:initialize_state, state})
  end

end
