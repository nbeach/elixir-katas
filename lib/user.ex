defmodule User do
  @enforce_keys [:name, :age]
  defstruct [:name, :age]
end
