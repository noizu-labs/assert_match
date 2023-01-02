defmodule Noizu.Assert.Records do
  require Record
  
  # type: ignore, include, inherit
  #Record.defrecord(:assert_filter, type: :ignore, is_nil?: false, value: nil)
  #Record.defrecord(:assert_constraint, constraint: nil,  is_nil?: false, value: nil)
  @type wrapper_type :: :stub | :ignore | :include | :inherit | :require
  Record.defrecord(:value_wrapper, type: nil, constraints: nil, is_stub?: false,  has_value?: false, value: nil)
  @type value_wrapper :: record(:value_wrapper, type: wrapper_type, constraints: any, is_stub?: boolean, has_value?: boolean, value: any)
  
  @type directive_type :: :ignore | :include
  Record.defrecord(:directive, type: nil, path: [])
  @type directive :: record(:directive, type: directive_type, path: (any -> any))
  
  
  
  def stub() do
    value_wrapper(type: :stub, is_stub?: true, has_value?: false, value: %{})
  end
  def stub(:map) do
    value_wrapper(type: :stub, is_stub?: true, has_value?: false, value: %{})
  end
  def stub(:list) do
    value_wrapper(type: :stub, is_stub?: true, has_value?: false, value: [])
  end
  def stub({:tuple, arity}) do
    t = List.duplicate(stub(), arity)
        |> List.to_tuple()
    value_wrapper(type: :stub, is_stub?: true, has_value?: false, value: t)
  end
  def stub(v) do
    value_wrapper(type: :stub, is_stub?: true, has_value?: false, value: v)
  end
  
end
