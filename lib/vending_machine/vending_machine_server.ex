defmodule VendingMachineServer do
  use GenServer


  def start_link(_) do
    GenServer.start_link(VendingMachineServer,  %VendingMachine{})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:display, _from, state) do
    {response, state} = VendingMachine.display(state)
    {:reply, response, state}
  end

  @impl true
  def handle_call({:insert_coin, coin}, _from, state) do
    {response, state} = VendingMachine.insert_coin(state, coin)
    {:reply, response, state}
  end

  @impl true
  def handle_call(:empty_coin_return, _from, state) do
    {response, state} = VendingMachine.empty_coin_return(state)
    {:reply, response, state}
  end

  @impl true
  def handle_call(:list_products, _from, state) do
    {response, state} = VendingMachine.list_products(state)
    {:reply, response, state}
  end

  @impl true
  def handle_call({:dispense, product_name}, _from, state) do
    {response, state} = VendingMachine.dispense(state, product_name)
    {:reply, response, state}
  end

  @impl true
  def handle_cast(:return_coins, state) do
    {_, state} = VendingMachine.return_coins(state)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:initialize_state, new_state}, _) do
    {:noreply, new_state}
  end

end
