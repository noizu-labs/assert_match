defprotocol Noizu.Assert.Protocol.ValueWrapper do
  @fallback_to_any true
  def value(any)
  def has_value?(any)
  def propagate(any)
end

defimpl Noizu.Assert.Protocol.ValueWrapper, for: Any do
  require Record
  require Noizu.Assert.Records
  
  
  def value(v), do: v
  
  def has_value?(_), do: true

  def propagate(v) when is_map(v) do
    v
    |> Enum.map(fn({k,v}) -> {k, Noizu.Assert.Protocol.ValueWrapper.propagate(v)} end)
    |> Map.new()
    |> then(&(Noizu.Assert.Records.value_wrapper(type: :inherit, has_value?: true, value: &1)))
  end
  def propagate(v)  when is_struct(v) do
    v
    |> Enum.map(fn({k,v}) -> {k, Noizu.Assert.Protocol.ValueWrapper.propagate(v)} end)
    |> Map.new()
    |> then(&(Noizu.Assert.Records.value_wrapper(type: :inherit, has_value?: true, value: Map.merge(v, &1))))
  end
  def propagate(v)  when is_list(v) do
    v
    |> Enum.map(&(Noizu.Assert.Protocol.ValueWrapper.propagate(&1)))
    |> then(&(Noizu.Assert.Records.value_wrapper(type: :inherit, has_value?: true, value: &1)))
  end
  def propagate(v) when is_tuple(v) do
    cond do
      Record.is_record(v, :value_wrapper) ->
        t = Noizu.Assert.Records.value_wrapper(v, :type)
        cond do
          t in [:stub] ->
            Noizu.Assert.Records.value_wrapper(
              type: :inherit,
              has_value?: Noizu.Assert.Records.value_wrapper(v, :has_value?),
              value: Noizu.Assert.Records.value_wrapper(v, :value)
                     |> Noizu.Assert.Protocol.ValueWrapper.propagate()
            )
          :else -> v
        end
      :else ->
        v
        |> Tuple.to_list()
        |> Enum.map(&(Noizu.Assert.Protocol.ValueWrapper.propagate(&1)))
        |> List.to_tuple()
        |> then(&(Noizu.Assert.Records.value_wrapper(type: :inherit, has_value?: true, value: &1)))
    end
  end
  def propagate(v) do
    Noizu.Assert.Records.value_wrapper(
      type: :inherit,
      has_value?: true,
      value: v
    )
  end

end
