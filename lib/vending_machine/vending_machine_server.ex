defmodule VendingMachineServer do
  use GenServer
  import Map, only: [put: 3, update!: 3]

  defstruct coin_return: [], coins: [], credit: [], message: nil, inventory: []

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:display, _from, state) do
    cond do
      state.message !== nil -> {:reply, state.message, put(state, :message, nil)}
      !Enum.empty?(state.credit) -> {:reply, format_credit(state.credit), state}
      true -> {:reply, "INSERT COIN", state}
    end
  end

  @impl true
  def handle_call({:insert_coin, coin}, _from, state) do
    coin_value = Coins.get_coin_value(coin)

    if(coin_value === :invalid) do
      {:reply, :invalid_coin, update!(state, :coin_return, &([coin] ++ &1))}
    else
      {:reply, :ok, update!(state, :credit, &(&1 ++ [coin]))}
    end
  end

  @impl true
  def handle_call(:empty_coin_return, _from, state) do
    {:reply, state.coin_return, put(state, :coin_return, [])}
  end

  @impl true
  def handle_call(:list_products, _from, state) do
    {:reply, Inventory.list_products(state.inventory), state}
  end

  @impl true
  def handle_call({:dispense, product_name}, _from, state) do
    {item, updated_inventory} = Inventory.dispense_item(state.inventory, product_name)

    cond do
      item === nil ->
        {:reply, false, put(state, :message, "SOLD OUT")}

      item.product.price > Coins.get_credit_value(state.credit) ->
        {:reply, false, put(state, :message, format_value(item.product.price))}

      true ->
        {:reply, true,
         state
         |> put(:inventory, updated_inventory)
         |> update!(:coin_return, &(&1 ++ Coins.make_change(state.credit, item.product.price)))
         |> put(:credit, [])
         |> put(:message, "THANK YOU")}
    end
  end

  @impl true
  def handle_cast(:return_coins, state) do
    new_state =
      state
      |> update!(:coin_return, &(state.credit ++ &1))
      |> put(:credit, [])

    {:noreply, new_state}
  end

  defp format_credit(credit) do
    credit
    |> Coins.get_credit_value()
    |> format_value()
  end

  defp format_value(value) do
    Float.to_string(value / 100)
  end
end
