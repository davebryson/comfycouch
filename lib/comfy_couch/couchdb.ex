
defmodule ComfyCouch.Couchdb do 
    @moduledoc """
        GenServer wrapper around couchbeam client. Maintains state of 
        the current server and database
    """
    use GenServer

    def start do
        start("http://127.0.0.1:5984")
    end

    def start(url) do
        GenServer.start_link(__MODULE__, [url: url], name: ComfyCouch.Couchdb)
    end

    def server_info do
        GenServer.call(__MODULE__,:server_info)
    end

    def use_or_create_db(name) do
        GenServer.call(__MODULE__,{:use_db, name})
    end

    def delete_db(name) do
        GenServer.call(__MODULE__,{:delete_db, name})
    end

    def save(doc) do
        GenServer.call(__MODULE__,{:insert, doc})
    end

    def get_doc(id) do
        GenServer.call(__MODULE__,{:get_doc, id})
    end

    def delete_doc(id,rev) do
        GenServer.call(__MODULE__,{:delete_doc, id, rev})
    end

    def stop do
        GenServer.call(__MODULE__,:stop)
    end

    def init(args) do
        {:ok, _} = :application.ensure_all_started(:couchbeam)
        server = :couchbeam.server_connection(args[:url], [])
        state = %{
            server: server,
            db: nil,
            dbname: nil
        }
        {:ok, state}
    end

    def handle_call(:server_info, _from, state) do
        {:ok, {version}} = :couchbeam.server_info(state.server)
        {:reply, {:ok,Enum.into(version,%{})}, state}
    end

    def handle_call({:use_db, name}, _from, state) do
        {:ok,db} = :couchbeam.open_or_create_db(state.server,name)
        {:reply, {:ok, name}, %{state | db: db, dbname: name}}
    end

    def handle_call({:delete_db, dbname}, _from, state) do
        result = :couchbeam.delete_db(state.server, dbname)
        if dbname == state.dbname do
            {:reply, result, %{state | dbname: nil, db: nil}}
        else
            {:reply, result, state} 
        end
    end

    def handle_call({:insert, doc}, _from, state) do
        {:ok, result} = :couchbeam.save_doc(state.db, {doc})
        {:reply, {:ok, result}, state}
    end

    def handle_call({:get_doc, id}, _from, state) do
        {:ok, result} = :couchbeam.open_doc(state.db, id)
        {:reply, {:ok, result}, state}
    end

    def handle_call({:delete_doc, id, rev}, _from, state) do
        {:ok, result} = :couchbeam.delete_doc(state.db, {[{"_id", id}, {"_rev", rev}]})
        {:reply, {:ok, result}, state}
    end
   
    
    def handle_call(:stop, _from, state) do
        {:stop, "shutdown", %{}}
    end

    def handle_call(_, _from, state) do
        {:reply, "bad call", state}
    end

    def terminate(reason,state) do
        :couchbeam.stop()
        :ok
    end

    def keyword_to_tuples([h | t], acc) do
        {name, value} = h
        acc1 = [{to_string(name),value} | acc]
        keyword_to_tuples(t, acc1)
    end
    
    def keyword_to_tuples([], acc) do
        acc
    end

end