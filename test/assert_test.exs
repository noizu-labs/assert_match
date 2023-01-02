defmodule Noizu.AssertTest do
  use ExUnit.Case, async: true
  use Noizu.Assert
  #  doctest AssertMatch
  @moduletag lib: :noizu_assert

  require Noizu.Assert.Records
  import Noizu.Assert.Records

  alias Noizu.Assert.Access, as: NAccess
  
  describe "Intermediate Data Structure Setup" do
    @describetag noizu_assert: :setup
    
    test "start_from_scratch" do
      a = expected_value_constraint()
      assert is_struct(a, Noizu.Assert.ExpectedValue.Constraint)
    end
    
    test "start_with_expected_value" do
      a = expected_value_constraint(%Noizu.Assert.Test.Foo{})
      assert is_struct(a, Noizu.Assert.ExpectedValue.Constraint)
      assert is_struct(a.rhs, Noizu.Assert.Test.Foo)
    end

    test "add filters" do
      a = expected_value_constraint()
          |> ignore_in([NAccess.key(:ab)])
          |> include_in([NAccess.key(:ab),NAccess.key(:ab_a)])
          |> ignore_in([NAccess.key(:ab),NAccess.key(:ab_a),NAccess.key(:ab_a_b)])

      assert length(a.filters) == 3
      assert directive(Enum.at(a.filters,0), :type) == :ignore
      assert directive(Enum.at(a.filters,1), :type) == :include
      assert directive(Enum.at(a.filters,2), :type) == :ignore
      
      assert length(directive(Enum.at(a.filters, 0), :path)) == 3
      assert length(directive(Enum.at(a.filters, 2), :path)) == 1
    end


    test "apply filters" do
      actual = %Noizu.Assert.Test.Foo{}
      expected = %Noizu.Assert.Test.Foo{}
                 |> put_in([Access.key(:ab),Access.key(:ab_a),Access.key(:ab_a_a)], 22)
                 |> put_in([Access.key(:ab),Access.key(:ab_a),Access.key(:ab_a_b)], :forget_about_it)
                 
      a = expected_value_constraint()
          |> ignore_in([NAccess.key(:ab)])
          |> include_in([NAccess.key(:ab),NAccess.key(:ab_a)])
          |> ignore_in([NAccess.key(:ab),NAccess.key(:ab_a),NAccess.key(:ab_a_b)])
          |> ignore_in([NAccess.key(:ab),NAccess.key(:ab_a),NAccess.key(:ab_a_g),NAccess.key(:ab_a_g_a),NAccess.key(:ab_a_g_a_a)])
          |> then(&(%{&1| lhs: actual, rhs: expected}))
          |> Noizu.Assert.Driver.__apply_filters__()

      IO.inspect a
      
    end


  end
  
  
end
