


#foo = fn -> IO.puts "Hello world from Elixir" end
#
#
#spawn foo
#spawn foo
#spawn foo


#parent = self()
#
#spawn fn ->
#  send(parent, {:action, "do a thing"})
#end


#receive do
#    {:action, action} -> IO.puts ~s(Action is: #{action})
##    {:world} -> "won't match"
#end


spawn_link fn -> raise "oops" end
