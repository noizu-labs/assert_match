defmodule Noizu.Assert do
  
  defmacro __using__(options \\ nil) do
    quote do
        require Noizu.Assert.Driver
        import Noizu.Assert.Driver
    end
  end
  
end
