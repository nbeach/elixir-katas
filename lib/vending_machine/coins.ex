defmodule Coins do
  def make_change(credit, sale_price) do
    change_to_make = get_credit_value(credit) - sale_price

    {quarters, quarter_remainder} = change_for_coin(change_to_make, :quarter)
    {dimes, dime_remainder} = change_for_coin(quarter_remainder, :dime)
    {nickels, _} = change_for_coin(dime_remainder, :nickel)

    quarters ++ dimes ++ nickels
  end

  def get_credit_value(credit) do
    credit
    |> Enum.map(&get_coin_value/1)
    |> Enum.reduce(0, fn next, total -> total + next end)
  end

  @spec get_coin_value(atom) :: atom | integer
  def get_coin_value(coin) do
    case coin do
      :quarter -> 25
      :dime -> 10
      :nickel -> 5
      _ -> :invalid
    end
  end

  defp change_for_coin(change_to_make, coin) do
    coin_value = get_coin_value(coin)
    coin_count = div(change_to_make, coin_value)
    remaining_change_to_make = rem(change_to_make, coin_value)

    coins =
      case coin_count do
        0 -> []
        _ -> Enum.map(1..coin_count, fn _ -> coin end)
      end

    {coins, remaining_change_to_make}
  end
end
