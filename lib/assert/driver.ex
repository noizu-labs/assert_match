defmodule Noizu.Assert.Driver do
  require Record
  require Noizu.Assert.Records
  import Noizu.Assert.Records
  
  def expected_value_constraint() do
    %Noizu.Assert.ExpectedValue.Constraint{}
  end
  
  def expected_value_constraint(initial) do
    %Noizu.Assert.ExpectedValue.Constraint{rhs: initial}
  end
  
  def include_in(constraint, path) do
    insert = directive(type: :include, path: path)
    update_in(constraint, [Access.key(:filters)], &([insert| (&1 || [])]))
  end

  def ignore_in(constraint, path) do
    insert = directive(type: :ignore, path: path)
    update_in(constraint, [Access.key(:filters)], &([insert| (&1 || [])]))
  end
  
  def __apply_filters__(constraint) do
    Enum.reduce(constraint.filters, constraint, fn(filter, acc) ->
      acc
      |> __apply_filter__(filter)
    end)
  end

  def __apply_filter__(constraint, filter) do
    constraint
    |> update_in([Noizu.Assert.Access.key(:lhs) | directive(filter, :path)], &(__apply_filter_inner__(&1, filter)))
    |> update_in([Noizu.Assert.Access.key(:rhs) | directive(filter, :path)], &(__apply_filter_inner__(&1, filter)))
  end
  
  def __apply_filter_inner__(existing_value, filter) do
    wrapper = case directive(filter, :type) do
                :include -> :include
                :ignore -> :ignore
              end
    cond do
      Record.is_record(existing_value, :value_wrapper) ->
        cond do
          value_wrapper(existing_value, :type) == :stub ->
            u = Noizu.Assert.Protocol.ValueWrapper.propagate(existing_value)
            value_wrapper(u, type: wrapper)
          :else ->
            value_wrapper(existing_value, type: wrapper)
        end
      existing_value == :__not_set__ ->
        value_wrapper(type: wrapper, constraints: nil, has_value?: false, value: nil)
      :else ->
        # @todo has_value? may be incorrect: follow up on this
        value_wrapper(type: wrapper, constraints: nil, has_value?: true, value: Noizu.Assert.Protocol.ValueWrapper.propagate(existing_value))
    end
  end



end
