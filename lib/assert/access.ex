defmodule Noizu.Assert.Access do
  @moduledoc """
  todo I need to provide my own implementation of get_in, update_in that supports dynamic creation and manipulation of tuples, etc.
  """
  require Record
  require Noizu.Assert.Records
#
#  defmodule Data do
#    defstruct [
#      path: [],
#      has_value?: false,
#      value: nil,
#    ]
#  end
#
#  def key(key, default \\ Noizu.Assert.Access.Default) do
#  # Generate method matching signature expected by kernel with extended support for inference.
#    fn
#      :type, _, _ -> {:key, key}
#      :get, data, next ->
#        n = case data do
#              %Noizu.Assert.Access.Data{value: Noizu.Assert.Access.Default} ->
#                data
#                |> update_in([Access.key(:path)], &([{:key, key} | (&1 || [])]))
#                |> put_in([Access.key(:has_value?)], false)
#                |> put_in([Access.key(:value)], default)
#              %Noizu.Assert.Access.Data{value: v} when is_map(v) ->
#                data
#                |> update_in([Access.key(:path)], &([{:key, key} | (&1 || [])]))
#                |> put_in([Access.key(:has_value?)], Map.has_key?(data.value, key))
#                |> update_in([Access.key(:value)], &(Map.get(&1, key, default)))
#              native when is_map(data) ->
#                %Noizu.Assert.Access.Data{
#                  path: [{:key, key}],
#                  value: Map.get(data, key, default),
#                  has_value?: Map.has_key?(data.value, key)
#                }
#              nil ->
#                data
#                |> update_in([Access.key(:path)], &([{:key, key} | (&1 || [])]))
#                |> put_in([Access.key(:has_value?)], false)
#                |> put_in([Access.key(:value)], default)
#            end
#        next.(n)
#      :get_and_update, data, next ->
#        n = case data do
#              %Noizu.Assert.Access.Data{value: Noizu.Assert.Access.Default} ->
#                data
#                |> update_in([Access.key(:path)], &([{:key, key} | (&1 || [])]))
#                |> put_in([Access.key(:has_value?)], false)
#                |> put_in([Access.key(:value)], default)
#              %Noizu.Assert.Access.Data{value: v} when is_map(v) ->
#                data
#                |> update_in([Access.key(:path)], &([{:key, key} | (&1 || [])]))
#                |> put_in([Access.key(:has_value?)], Map.has_key?(data.value, key))
#                |> update_in([Access.key(:value)], &(Map.get(&1, key, default)))
#              native when is_map(data) ->
#                %Noizu.Assert.Access.Data{
#                  path: [{:key, key}],
#                  value: Map.get(data, key, default),
#                  has_value?: Map.has_key?(data.value, key)
#                }
#              nil ->
#                data
#                |> update_in([Access.key(:path)], &([{:key, key} | (&1 || [])]))
#                |> put_in([Access.key(:has_value?)], false)
#                |> put_in([Access.key(:value)], default)
#            end
#        case next.(n) do
#          {get, update} ->
#
#            {get, Map.put(data, key, update)}
#          :pop ->
#
#            {value, Map.delete(data, key)}
#        end
#    end
#  end




  def key(k, d \\ %{}) do
    Access.key(k, d)
  end
  
  def at(k) do
    Access.at(k)
  end
  
  def elem(k) do
    Access.elem(k)
  end

  def filter(k) do
    Access.filter(k)
  end

  def all() do
    Access.all()
  end

end