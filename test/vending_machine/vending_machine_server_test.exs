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
    test "shows an insert coin message on the display", %{ pid: pid } do
      assert GenServer.call(pid, :display) === "INSERT COIN"
    end
  end

  describe "when a coin is inserted and it is an accepted coin" do
    test "displays credit for the coin on the display", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      assert GenServer.call(pid, :display) === "0.25"
    end

    test "tells that the coin was accepted", %{ pid: pid } do
      assert GenServer.call(pid, {:insert_coin, :quarter}) === :ok
    end
  end

  describe "when a coin is inserted and it is an unrecognized coin" do
    test "tells that the coin was rejected", %{ pid: pid } do
      assert GenServer.call(pid, {:insert_coin, :sasquatch}) === :invalid_coin
    end

    test "adds no credit", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :sasquatch})
      assert GenServer.call(pid, :display) == "INSERT COIN"
    end

    test "puts the coin in the coin return", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :sasquatch})
      assert GenServer.call(pid, :empty_coin_return) == [:sasquatch]
    end
  end

  describe "when the coin return contents is emptied" do
    test "clears the coin return contents", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :sasquatch})
      GenServer.call(pid, :empty_coin_return)
      assert GenServer.call(pid, :empty_coin_return) == []
    end
  end

  describe "when the coin return is pushed" do
    test "puts the change in the coin return", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :nickel})

      GenServer.cast(pid, :return_coins)

      assert GenServer.call(pid, :empty_coin_return) === [:quarter, :nickel]
      assert GenServer.call(pid, :display) == "INSERT COIN"
    end
  end

  test "tells what products are available", %{ pid: pid } do
    assert GenServer.call(pid, :list_products) === [
             %{name: "Cola", price: 100},
             %{name: "Chips", price: 50},
             %{name: "Candy", price: 65}
           ]
  end

  describe "when a product is selected and it is in stock and there is sufficient credit" do
    test "dispenses the product", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})

      assert GenServer.call(pid, {:dispense, "Chips"}) == true
    end

    test "displays thank you on the display", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})

      assert GenServer.call(pid, :display) == "THANK YOU"
    end

    test "displays insert coin after displaying the thank you", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})
      GenServer.call(pid, :display)

      assert GenServer.call(pid, :display) == "INSERT COIN"
    end

    test "depletes product inventory upon dispensing", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})

      assert GenServer.call(pid, {:dispense, "Chips"}) === false
      assert GenServer.call(pid, :display) == "SOLD OUT"
    end

    test "returns the remaining change", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Candy"})

      assert GenServer.call(pid, :empty_coin_return) === [:dime]
    end
  end

  describe "when a product is selected and it is in stock and there is insufficient credit" do
    test "does not dispense the product", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      assert GenServer.call(pid, {:dispense, "Candy"}) === false
    end

    test "displays the product price on the display", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Candy"})
      assert GenServer.call(pid, :display) === "0.65"
    end

    test "returns to displaying the current credit after displaying the product price", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Candy"})
      GenServer.call(pid, :display)

      assert GenServer.call(pid, :display) === "0.25"
    end
  end

  describe "when a product is selected and it is in stock and it is sold out" do
    test "does not dispense the product", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})

      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})

      assert GenServer.call(pid, {:dispense, "Chips"}) === false
    end

    test "displays sold out on the display", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})

      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})

      assert GenServer.call(pid, :display) === "SOLD OUT"
    end

    test "returns to displaying insert coin after displaying sold out", %{ pid: pid } do
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})

      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:insert_coin, :quarter})
      GenServer.call(pid, {:dispense, "Chips"})
      GenServer.call(pid, :display)

      assert GenServer.call(pid, :display) === "0.5"
    end
  end
end
