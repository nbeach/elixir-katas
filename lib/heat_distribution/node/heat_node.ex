defmodule HeatNode do

  def heatValue(current, top, bottom, left, right) do
    average = (current + top + bottom + left + right / 5)
    average
  end

end
