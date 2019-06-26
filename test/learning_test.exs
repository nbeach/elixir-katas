defmodule LearningTest do
  use ExUnit.Case


  test "tuples" do
    tuple = {"one", 2}
    other = Tuple.append(tuple, "three")
    assert elem(other, 2) == "three"
  end


  test "lists" do
    list = [1,2]
    other = List.insert_at(list, 2, 3)
    assert length(other)  == 3
    assert Enum.at(other, 2) == 3
  end

  test "list concat" do
    list1 = [1]
    list2 = [2]
    assert list1 ++ list2 == [1,2]
  end

  test "list recursive definition" do
    list = [1 | [2, 3]]
    assert list == [1,2,3]
  end

  test "maps" do
    map = %{ :key => "value", "foo" => "bar", 4 => 5}
    assert map["foo"] == "bar"
    assert map.key == "value" #Atom keys have a special accessor
  end

  test "map update field" do
    map = %{ :key => "value", "foo" => "bar", 4 => 5}
    updated = %{ map | :key => "whoosh"}
    assert updated.key == "whoosh"
  end

  test "map add field" do
    map = %{ :key => "value", "foo" => "bar", 4 => 5}
    updated = Map.put(map, :key, "whoosh")
    assert updated.key == "whoosh"
  end

  test "binary string interpolation" do
    string = "foo"
    interpolated = "this string has '#{string}'"

    assert interpolated == "this string has 'foo'"
  end

  test "char list string" do
    string = 'foo'

    assert Enum.at(string, 1) == 111
  end

  test "ranges" do
    range = 1..5

    assert 2 in range == true
  end

  test "range map" do
    range = Enum.map(1..3, fn(val) ->  val + 1 end)

    assert range == [2,3,4]
  end


  test "keyword lists" do
    list = [foo: "bar", one: 2]

    assert Keyword.get(list, :one) == 2
  end

  test "structs with required values" do
    %User{ name: "John Doe", age: 5 }
#    This fails to compile because age is missing
#    %User{ name: "John Doe" }
  end

  test "macros" do
    defmodule A do

      defmacro make_foo() do
        quote do
          def foo() do
            "FOO!"
          end
        end
      end

    end

    defmodule B do
      import A

      make_foo()
    end

    assert B.foo() === "FOO!"
  end

end
