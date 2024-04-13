# AssertMatch Library

This library provides tools for building custom assertion functions in Elixir for more expressive and informative test failures.  Instead of relying solely on built-in assertion functions, which may offer limited flexibility and feedback, AssertMatch enables you to define assertions tailored to your specific data structures and comparison requirements. This leads to more focused and informative test failures, making it easier to identify and address issues in your code. 

## Features

* **Flexible Assertions:** Create custom assertions tailored to your specific needs. This allows you to define comparison logic that goes beyond simple equality checks and handles complex data structures effectively.
* **Granular Comparisons:** Focus on relevant data sections and ignore irrelevant ones. With AssertMatch, you can pinpoint specific elements within your data structures for comparison, ignoring fields or sections that are not relevant to the current test case. This improves the clarity and conciseness of your assertions.
* **Informative Failures:**  Display clear messages and diffs when assertions fail. AssertMatch provides detailed information about how the actual and expected values differ, making it easier to understand the root cause of test failures and take corrective action.

## Installation

To use the AssertMatch library in your Elixir project, add it as a dependency in your `mix.exs` file:

```elixir
def deps do
  [
    {:github, "~> 0.1.0", "noizu-labs/assert_match"}
  ]
end
```

After adding the dependency, run `mix deps.get` to fetch and install the library.

## Usage

Building custom assertions with AssertMatch involves several key steps:

1. **Define Custom Assertions:** Start by creating a function for your custom assertion. Within this function, use the `expected_value_constraint` function to initialize a constraint structure. This structure will hold information about the expected value, filters, and checks that define your assertion. 
2. **Utilize Access Functions:** To access specific data elements within your structures, use the functions provided by the `Noizu.Assert.Access` module. Functions like `key`, `at`, and `elem` allow you to navigate through nested structures and pinpoint the elements you want to compare. 
3. **Apply Filters:** AssertMatch allows you to focus your comparisons on specific data sections while ignoring others. Use functions like `ignore_in` and `include_in` to define which parts of your data structures should be considered during comparison. This helps you avoid unnecessary checks and makes your assertions more targeted.
4. **Apply Checks:** Implement the comparison logic within your custom assertion function. You can use various approaches here, such as direct value comparisons, range checks, or even custom functions to evaluate specific conditions. The goal is to determine whether the actual value meets the expectations defined by your constraint structure.
5. **Integrate in Tests:** Once you have defined your custom assertion functions, use them within your test cases. When an assertion fails, AssertMatch will provide detailed output highlighting the differences between the actual and expected values, making it easier to identify and resolve the issue.

## Examples

Here are some examples of how you can use AssertMatch to create custom assertions:

* **Comparing Specific Fields:** Suppose you have a struct representing a car with fields like `make`, `model`, `year`, and `color`. You want to create an assertion that compares only the `make` and `model` fields, ignoring the rest. 

```elixir
defmodule MyApp.Test.CustomAsserts do
  use Noizu.Assert

  def assert_make_and_model(actual, expected) do
    expected_value_constraint(expected)
    |> ignore_in([Access.key(:year), Access.key(:color)])
    |> then(&(Noizu.Assert.match(actual, &1)))
  end
end
```

In this example, `ignore_in` is used to exclude the `year` and `color` fields from the comparison. The `then` function applies the `Noizu.Assert.match` function to perform the actual comparison between the filtered expected value and the actual value.

* **Ignoring Nested Sections:** Imagine you have a nested data structure representing a user profile with sections like `personal_info`, `contact_details`, and `preferences`. You want to create an assertion that compares only the `personal_info` section, ignoring the rest.

```elixir
defmodule MyApp.Test.CustomAsserts do
  use Noizu.Assert

  def assert_personal_info(actual, expected) do
    expected_value_constraint(expected)
    |> ignore_in([Access.key(:contact_details), Access.key(:preferences)])
    |> then(&(Noizu.Assert.match(actual, &1)))
  end
end
```

This example demonstrates how to ignore specific nested sections using `ignore_in`. The assertion will only compare the `personal_info` section of the actual and expected values. 
* **Filtering Values:** Consider a scenario where you have a list of numbers and you want to create an assertion that checks if all numbers are even. 

```elixir
defmodule MyApp.Test.CustomAsserts do
  use Noizu.Assert

  def assert_all_even(numbers) do
    expected_value_constraint([])
    |> check(fn(x) -> rem(x, 2) == 0 end)
    |> then(&(Noizu.Assert.match(numbers, &1)))
  end
end
```

This example uses the `check` function to apply a custom function that checks if each element in the list is even. The assertion will fail if any odd numbers are present in the list.

## Internals/Implementation

Understanding the internal workings of AssertMatch can provide valuable insights into how the library achieves its functionality. Here are some key aspects of its implementation:

* **Constraint Structure:** At the heart of AssertMatch lies the `Noizu.Assert.ExpectedValue.Constraint` struct. This structure holds information that defines the expected behavior of an assertion. It includes fields for:
    * `rhs`: The expected value to compare against. 
    * `lhs`: The actual value being tested.
    * `filters`: A list of directives (e.g., `:ignore` or `:include`) that specify which parts of the data structure should be considered during comparison. 
    * `checks`: A list of functions or conditions that are applied to the data elements to determine if they meet the expected criteria.
* **Access and Filtering:** The `Noizu.Assert.Access` module provides functions that facilitate accessing and filtering data within structures. These functions use a key-based approach to navigate through nested structures and target specific elements. The filtering mechanism relies on directives stored within the constraint structure to determine which elements should be included or excluded from comparison.
* **Data Wrapping:** The `Noizu.Assert.Protocol.ValueWrapper` protocol and its implementations play a crucial role in managing the data used during comparisons. They provide a consistent way to wrap values within data structures, ensuring that filtering and propagation operations are handled correctly regardless of the underlying data type (e.g., maps, lists, tuples). 
* **Comparison Logic:** The actual comparison process occurs within the `Noizu.Assert.match` function. This function traverses the data structures, applying the specified filters and checks to determine if the actual value conforms to the expected structure and values. If any discrepancies are found, detailed information about the differences is collected and presented in the assertion failure message.

## Contributing

Contributions to the AssertMatch library are welcome! Here's how you can contribute:

* **Fork the Repository:** Start by forking the AssertMatch repository on GitHub. This creates your own copy of the repository where you can make changes.
* **Implement Changes:** Make the desired changes or additions to the codebase. This could involve bug fixes, new features, improved documentation, or anything else that enhances the library.
* **Submit Pull Request:** Once you are satisfied with your changes, submit a pull request to the original AssertMatch repository. This allows the maintainers to review your changes and potentially merge them into the main codebase.
* **Follow Guidelines:** When contributing, please ensure that your code adheres to the project's style guidelines and is well-tested. This helps maintain the quality and consistency of the library. 

## License

The AssertMatch library is licensed under the MIT License, which allows for flexible use and distribution. You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, subject to the conditions of the license. 

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
