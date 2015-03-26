defmodule ComfyCouch do
    @moduledoc """
        Start/Stop the GenServer wrapper to couchdb
    """
    @doc false
    defmacro __using__(_opts) do
        quote do
            import ComfyCouch
        end
    end

    @doc """
        Start a client connection to a localhost CouchDB
    """
    @spec start :: :ok | { :error, any }
    def start do
        # start couchdb connection
        ComfyCouch.Couchdb.start
    end

    @doc """
        Start a client connection to CouchDB at the given URL
    """
    @spec start(string) :: :ok | { :error, any }
    def start(url) do
        ComfyCouch.Couchdb.start(url)
    end

    @doc """
        Return server information as a map
    """
    @spec server_info :: %{}
    def server_info do
        ComfyCouch.Couchdb.server_info
    end

    @doc """
        Stop Couchdb client
    """
    def stop do
        ComfyCouch.Couchdb.stop
    end
end
