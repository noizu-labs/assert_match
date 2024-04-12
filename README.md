# Assert

The AssertMatch Library provides some helper utility and protocols for writing reusable custom asserts statements in your
test code that make it straight forward show exactly how your actual and expected values diverged in a single assert. 

```elixir
# Test case using a custom assert assert_make_and_model built with this library.
import MyApp.Test.CustomAsserts
#...
@my_datsun %Car{make: :Datsun, year: 1983, model: :"280zx", color: :mauve}
#...
actual = SUT.get_car(year: 1985, model: :"280zx", color: :black)
assert_make_and_model(actual, @my_datsun)
assert actual.year != @my_datsun.year
assert actual.color != @my_datsun.color

assert_will_fail_variable_name = SUT.get_car(year: 2020, model: :"Z4", make: :BMW, color: :hot_pink)
assert_make_and_model(assert_will_fail_variable_name, @my_datsun, "I was expecting a datsun")
# Test fails with message like:
# > Test Failure: 'I was expecting a datsun' 
# > `assert_will_fail_variable_name` make and model did not match @my_datsun make and model.
# >  assert_will_fail_variable_name:
# >   - make: :BMW
# >   - model: :Z4
# >  @my_datsun:
# >   - make: :Datsun
# >   - model: :280zx

```


Building custom asserts works or running custom comparison logic works as follows:

```elixir
require Noizu.Assert
alias Noizu.Assert.Access, as: Noizu.Access

@doc """
  Compare only subset of actual and expected objects, ignore rest.
"""
def custom_assert_foo_biz_bop(actual,expected) do 
  assert_expected(expected)
  |> check_type() # will verify a and b struct.
  |> check_vsn() # will verify vsn field (if present) or throw if not present on a or b.
  |> check([Noizu.Access.key(:foo, :not_set), Noizu.Access.all(), Noizu.Access.assert_type(MyStruct), Noizu.Access.key(:bop)]) # Compare all entries of b.foo[*].bop to a.foo[*].bop  
  |> check([Noizu.Access.key(:bar, :not_set), Noizu.Access.filter_key(&(&1 in [:alpha, :beta, :omega]))])
  |> check([Noizu.Access.key(:bop, :not_set), Noizu.Access.filter_value(&(&1 in [:alpha, :beta, :omega]))])
  |> check_approx([Noizu.Access.key(:bop, :not_set)], 0.05)
  |> ignore_remaining() 
  |> then(&(Noizu.Assert.match(actual, &1)))
end

@doc """
  Ignore nested sections, but explicitly check a few components inside those sections as well as all top level values.
"""
def custom_assert_foo_biz_bop(actual,expected) do
  assert_expected(expected)
  |> check_type() # will verify a and b struct.
  |> check_type() # will verify vsn field (if present) or throw if not present on a or b.
  |> ignore_in([Noizu.Access.key(:foo), Noizu.Access.filter_key(&(&1 in [:biz, :bop]))])
  |> include_in([Noizu.Access.key(:foo), Noizu.Access.key(:biz), Noizu.Access.key(:pop)])
  |> check([Noizu.Access.key(:foo), Noizu.Access.filter_key(&(&1 in [:biz, :bop])), Noizu.Access.key(:value)])
  |> check_approx([Noizu.Access.key(:bop, :not_set)], 0.05)
  |> then(&(Noizu.Assert.match(actual, &1)))
end
```



## Installation

```elixir
def deps do
  [
    {:github, "~> 0.1.0", "noizu-labs/assert_match"}
  ]
end
```

