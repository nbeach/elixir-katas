defmodule VendingMachine do
  import Map, only: [put: 3, update!: 3]

  def new() do
    %{ :coin_return => [], :credit => [] }
  end

  def display(state) do
    message = cond do
      !Enum.empty?(state.credit) -> format_credit(state.credit)
      true -> "INSERT COIN"
    end

    {message, state}
  end

  def insert_coin(state, coin) do
    coin_value = get_coin_value(coin)
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

  defp format_credit(credit) do
    total = credit
    |> Enum.map(&get_coin_value/1)
    |> Enum.reduce(0, fn next, total -> total + next end)

     Float.to_string(total / 100)
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
