defmodule VendingMachineServerTest do
  use ExUnit.Case

  setup do
    {:ok, pid} =
      GenServer.start_link(VendingMachineServer, %VendingMachineServer{
        inventory: [
          %{product: %{name: "Cola", price: 100}, quantity: 1},
          %{product: %{name: "Chips", price: 50}, quantity: 1},
          %{product: %{name: "Candy", price: 65}, quantity: 1}
        ]
      })

    {:ok, pid: pid}
  end

  describe "when no credit" do
    test "shows an insert coin message on the display", context do
      assert GenServer.call(context.pid, :display) === "INSERT COIN"
    end
  end

  describe "when a coin is inserted and it is an accepted coin" do
    test "displays credit for the coin on the display", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      assert GenServer.call(context.pid, :display) === "0.25"
    end

    test "tells that the coin was accepted", context do
      assert GenServer.call(context.pid, {:insert_coin, :quarter}) === :ok
    end
  end

  describe "when a coin is inserted and it is an unrecognized coin" do
    test "tells that the coin was rejected", context do
      assert GenServer.call(context.pid, {:insert_coin, :sasquatch}) === :invalid_coin
    end

    test "adds no credit", context do
      GenServer.call(context.pid, {:insert_coin, :sasquatch})
      assert GenServer.call(context.pid, :display) == "INSERT COIN"
    end

    test "puts the coin in the coin return", context do
      GenServer.call(context.pid, {:insert_coin, :sasquatch})
      assert GenServer.call(context.pid, :empty_coin_return) == [:sasquatch]
    end
  end

  describe "when the coin return contents is emptied" do
    test "clears the coin return contents", context do
      GenServer.call(context.pid, {:insert_coin, :sasquatch})
      GenServer.call(context.pid, :empty_coin_return)
      assert GenServer.call(context.pid, :empty_coin_return) == []
    end
  end

  describe "when the coin return is pushed" do
    test "puts the change in the coin return", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :nickel})

      GenServer.cast(context.pid, :return_coins)

      assert GenServer.call(context.pid, :empty_coin_return) === [:quarter, :nickel]
      assert GenServer.call(context.pid, :display) == "INSERT COIN"
    end
  end

  test "tells what products are available", context do
    assert GenServer.call(context.pid, :list_products) === [
             %{name: "Cola", price: 100},
             %{name: "Chips", price: 50},
             %{name: "Candy", price: 65}
           ]
  end

  describe "when a product is selected and it is in stock and there is sufficient credit" do
    test "dispenses the product", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})

      assert GenServer.call(context.pid, {:dispense, "Chips"}) == true
    end

    test "displays thank you on the display", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})

      assert GenServer.call(context.pid, :display) == "THANK YOU"
    end

    test "displays insert coin after displaying the thank you", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})
      GenServer.call(context.pid, :display)

      assert GenServer.call(context.pid, :display) == "INSERT COIN"
    end

    test "depletes product inventory upon dispensing", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})

      assert GenServer.call(context.pid, {:dispense, "Chips"}) === false
      assert GenServer.call(context.pid, :display) == "SOLD OUT"
    end

    test "returns the remaining change", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Candy"})

      assert GenServer.call(context.pid, :empty_coin_return) === [:dime]
    end
  end

  describe "when a product is selected and it is in stock and there is insufficient credit" do
    test "does not dispense the product", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      assert GenServer.call(context.pid, {:dispense, "Candy"}) === false
    end

    test "displays the product price on the display", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Candy"})
      assert GenServer.call(context.pid, :display) === "0.65"
    end

    test "returns to displaying the current credit after displaying the product price", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Candy"})
      GenServer.call(context.pid, :display)

      assert GenServer.call(context.pid, :display) === "0.25"
    end
  end

  describe "when a product is selected and it is in stock and it is sold out" do
    test "does not dispense the product", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})

      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})

      assert GenServer.call(context.pid, {:dispense, "Chips"}) === false
    end

    test "displays sold out on the display", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})

      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})

      assert GenServer.call(context.pid, :display) === "SOLD OUT"
    end

    test "returns to displaying insert coin after displaying sold out", context do
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})

      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:insert_coin, :quarter})
      GenServer.call(context.pid, {:dispense, "Chips"})
      GenServer.call(context.pid, :display)

      assert GenServer.call(context.pid, :display) === "0.5"
    end
  end
end
