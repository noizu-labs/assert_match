defmodule Noizu.Assert.Test.Foo do
  defstruct [
    a: 1,
    ab: %{ab_a: %{ab_a_a: 2, ab_a_b: 3, ab_a_c: %{ab_a_c_a: 4}}},
    b: 5,
    bc: 6,
    c: 7,
  ]
end