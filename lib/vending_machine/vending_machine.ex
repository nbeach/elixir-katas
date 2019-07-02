defmodule VendingMachine do
  import Map, only: [put: 3, update!: 3]

  @enforce_keys [:inventory]
  defstruct coin_return: [], coins: [], credit: [], message: nil, inventory: []

  def display(state) do
    cond do
      state.message !== nil -> {state.message, put(state, :message, nil)}
      !Enum.empty?(state.credit) -> {format_credit(state.credit), state}
      true -> {"INSERT COIN", state}
    end
  end

  def insert_coin(state, coin) do
    coin_value = Coins.get_coin_value(coin)
    if(coin_value === :invalid) do
      {:invalid_coin, update!(state, :coin_return, &([coin] ++ &1))}
    else
      {:ok, update!(state, :credit, &(&1 ++ [coin]))}
    end
  end

  def empty_coin_return(state) do
    {state.coin_return, put(state, :coin_return, [])}
  end

  def return_coins(state) do
    new_state = state
    |> update!(:coin_return, &(state.credit ++ &1))
    |> put(:credit, [])

    {nil, new_state}
  end

  def list_products(state) do
    {Inventory.list_products(state.inventory), state}
  end

  def dispense(state, product_name) do
    {item, updated_inventory} = Inventory.dispense_item(state.inventory, product_name)

    cond do
      item === nil -> {false, put(state, :message, "SOLD OUT")}
      item.product.price > Coins.get_credit_value(state.credit) -> { false, put(state, :message,  format_value(item.product.price)) }
      true -> {true, state
        |> put(:inventory, updated_inventory)
        |> update!(:coin_return, &(&1 ++ Coins.make_change(state.credit, item.product.price)))
        |> put(:credit, [])
        |> put(:message, "THANK YOU")
      }
    end
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
