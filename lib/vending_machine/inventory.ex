defmodule Inventory do
  def list_products(inventory) do
    for item <- inventory, do: item.product
  end

  def dispense_item(inventory, name) do
    requested_item = Enum.find(inventory, &(&1.product.name === name))

    cond do
      requested_item.quantity === 0 -> {nil, inventory}
      true -> {requested_item, decrement_item_quantity(inventory, requested_item)}
    end
  end

  defp decrement_item_quantity(inventory, item) do
    for current <- inventory do
      if current === item, do: Map.update!(current, :quantity, &(&1 - 1)), else: current
    end
  end
end
