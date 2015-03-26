defmodule ComfyCouch.Document do
    @moduledoc """
        CRUD calls for documents
    """
    @doc false
    defmacro __using__(_opts) do
        quote do
            import ComfyCouch.Document
        end
    end

    alias ComfyCouch.Couchdb

    def save(doc) do
        # convert to couchbeam format
        {:ok,{doc1}} = doc |> to_couch |> Couchdb.save
        from_couch(doc1, %{})
    end

    def get(id) do
        {:ok, {doc1}} = Couchdb.get_doc(id)
        from_couch(doc1, %{})
    end

    def delete(id,rev) do 
        Couchdb.delete_doc(id,rev)
    end

    # Converts maps and keywords to and from couchbeam format
    defp from_couch([{"_id",value} | t], acc) do
      acc1 = Map.put(acc, :id, value)
      from_couch(t,acc1)
    end
    defp from_couch([{"_rev",value} | t], acc) do
        acc1 = Map.put(acc, :rev, value)
        from_couch(t,acc1)
    end
    defp from_couch([{key,value} | t], acc) do
        k1 = if is_binary(key) do
            String.to_atom(key)
        else 
            key
        end  
        acc1 = Map.put(acc, k1, value)
        from_couch(t,acc1)
    end
    defp from_couch([], acc) do
      acc
    end
    
    defp to_couch(%{id: idv, rev: revid} = map) do
      m = Map.drop(map, [:id, :rev]) |> Map.put("_id", idv) |> Map.put("_rev", revid)
      Dict.to_list(m) |> check_nested_values([])
    end
    defp to_couch(%{id: idv} = map) do
      m = Map.drop(map, [:id]) |> Map.put("_id", idv)
      Dict.to_list(m) |> check_nested_values([])
    end
    defp to_couch(map) do
      Dict.to_list(map) |> check_nested_values([])
    end
    
    defp check_nested_values([{key, value} | t] = l, acc) do
      if is_map(value) do
        acc1 = [{key, Dict.to_list(value)} | acc]
        check_nested_values(t, acc1)
      else
        acc1 = [{key, value} | acc]
        check_nested_values(t, acc1)
      end
    end 
    defp check_nested_values([],acc) do
        acc
    end
    
end
