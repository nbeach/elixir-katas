defmodule VendingMachine do
  import Map, only: [put: 3, update!: 3]

  def new() do
    %{ :coin_return => [], :credit => 0 }
  end

  def display(state) do
    message = cond do
      state.credit > 0 -> format_credit(state.credit)
      true -> "INSERT COIN"
    end

    {message, state}
  end

  def insert_coin(state, coin) do
    coin_value = get_coin_value(coin)
    if(coin_value === :invalid) do
      {:invalid_coin, update!(state, :coin_return, &([coin] ++ &1))}
    else
      {:ok, update!(state, :credit, &(&1 + coin_value))}
    end
  end

  def empty_coin_return(state) do
    coins = state.coin_return
    {coins, put(state, :coin_return, [])}
  end

  defp format_credit(credit) do
    Float.round(credit / 100, 2) |> Float.to_string
  end

  defp get_coin_value(coin) do
    case coin do
      :quarter -> 25
      :dime -> 10
      :nickel -> 5
      _ -> :invalid
    end
  end

end
