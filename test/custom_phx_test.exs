defmodule CustomPhxTest do
  use ExUnit.Case
  doctest CustomPhx

  test "greets the world" do
    assert CustomPhx.hello() == :world
  end
end
