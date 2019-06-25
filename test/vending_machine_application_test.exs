defmodule VendingMachineApplicationTest do
  use ExUnit.Case, async: true

  describe "when no credit" do

    test "shows an insert coin message on the display" do
      VendingMachineApplication.start()
      assert VendingMachineApplication.display() == "INSERT COIN"
    end

  end

  describe "when a coin is inserted and it is an accepted coin" do

      test "displays credit for the coin on the display" do
        VendingMachineApplication.start()
        VendingMachineApplication.insert_coin(:quarter)
        assert VendingMachineApplication.display() === "0.25"
      end

      test "tells that the coin was accepted" do
        VendingMachineApplication.start()
        assert VendingMachineApplication.insert_coin(:quarter) === :ok
      end

  end

  describe "when a coin is inserted and it is an unrecognized coin" do

    test "tells that the coin was rejected" do
      VendingMachineApplication.start()
      assert VendingMachineApplication.insert_coin(:sasquatch) === :invalid_coin
    end

    test "adds no credit" do
      VendingMachineApplication.start()
      VendingMachineApplication.insert_coin(:sasquatch)
      assert VendingMachineApplication.display() == "INSERT COIN"
    end

    test "puts the coin in the coin return" do
      VendingMachineApplication.start()
      VendingMachineApplication.insert_coin(:sasquatch)
      assert VendingMachineApplication.empty_coin_return() == [:sasquatch]
    end

  end

  describe "when the coin return contents is emptied" do

    test "clears the coin return contents" do
      VendingMachineApplication.start()
      VendingMachineApplication.insert_coin(:sasquatch)
      VendingMachineApplication.empty_coin_return()
      assert VendingMachineApplication.empty_coin_return() == []
    end

  end

end
