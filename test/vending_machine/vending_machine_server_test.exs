defmodule VendingMachineServerTest do
  use ExUnit.Case

  setup do
    server = start_supervised!(VendingMachineServer)
    VendingMachineClient.initialize_state(server, %VendingMachine{
      inventory: [
        %{product: %{name: "Cola", price: 100}, quantity: 1},
        %{product: %{name: "Chips", price: 50}, quantity: 1},
        %{product: %{name: "Candy", price: 65}, quantity: 1}
      ]
    })
    {:ok, server: server}
  end

  describe "when no credit" do
    test "shows an insert coin message on the display", %{ server: server} do
      assert VendingMachineClient.display(server) == "INSERT COIN"
    end
  end

  describe "when a coin is inserted and it is an accepted coin" do
    test "displays credit for the coin on the display", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      assert VendingMachineClient.display(server) === "0.25"
    end

    test "tells that the coin was accepted", %{ server: server} do
      assert VendingMachineClient.insert_coin(server, :quarter) === :ok
    end
  end

  describe "when a coin is inserted and it is an unrecognized coin" do

    test "tells that the coin was rejected", %{ server: server} do
      assert VendingMachineClient.insert_coin(server, :sasquatch) === :invalid_coin
    end

    test "adds no credit", %{ server: server} do
      VendingMachineClient.insert_coin(server, :sasquatch)
      assert VendingMachineClient.display(server) == "INSERT COIN"
    end

    test "puts the coin in the coin return", %{ server: server} do
      VendingMachineClient.insert_coin(server, :sasquatch)
      assert VendingMachineClient.empty_coin_return(server) == [:sasquatch]
    end
  end

  describe "when the coin return contents is emptied" do
    test "clears the coin return contents", %{ server: server} do
      VendingMachineClient.insert_coin(server, :sasquatch)
      VendingMachineClient.empty_coin_return(server)
      assert VendingMachineClient.empty_coin_return(server) == []
    end
  end

  describe "when the coin return is pushed" do
    test "puts the change in the coin return", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :nickel)

      VendingMachineClient.return_coins(server)

      assert VendingMachineClient.empty_coin_return(server) === [:quarter, :nickel]
      assert VendingMachineClient.display(server) == "INSERT COIN"
    end
  end

  test "tells what products are available", %{ server: server} do
    products = VendingMachineClient.list_products(server)

    assert products === [
             %{name: "Cola", price: 100},
             %{name: "Chips", price: 50},
             %{name: "Candy", price: 65}
           ]
  end

  describe "when a product is selected and it is in stock and there is sufficient credit" do
    test "dispenses the product", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)

      assert VendingMachineClient.dispense(server, "Chips") == true
    end

    test "displays thank you on the display", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")

      assert VendingMachineClient.display(server) == "THANK YOU"
    end

    test "displays insert coin after displaying the thank you", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")
      VendingMachineClient.display(server)

      assert VendingMachineClient.display(server) == "INSERT COIN"
    end

    test "depletes product inventory upon dispensing", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")

      assert VendingMachineClient.dispense(server, "Chips") === false
      assert VendingMachineClient.display(server) == "SOLD OUT"
    end

    test "returns the remaining change", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Candy")

      assert VendingMachineClient.empty_coin_return(server) === [:dime]
    end
  end

  describe "when a product is selected and it is in stock and there is insufficient credit" do
    test "does not dispense the product", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      assert VendingMachineClient.dispense(server, "Candy") === false
    end

    test "displays the product price on the display", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Candy")
      assert VendingMachineClient.display(server) === "0.65"
    end

    test "returns to displaying the current credit after displaying the product price", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Candy")
      VendingMachineClient.display(server)

      assert VendingMachineClient.display(server) === "0.25"
    end
  end

  describe "when a product is selected and it is in stock and it is sold out" do
    test "does not dispense the product", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")

      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      assert VendingMachineClient.dispense(server, "Chips") === false
    end

    test "displays sold out on the display", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")

      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")
      assert VendingMachineClient.display(server) === "SOLD OUT"
    end

    test "returns to displaying insert coin after displaying sold out", %{ server: server} do
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")

      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.insert_coin(server, :quarter)
      VendingMachineClient.dispense(server, "Chips")
      VendingMachineClient.display(server)

      assert VendingMachineClient.display(server) === "0.5"
    end
  end
end
