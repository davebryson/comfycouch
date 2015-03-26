defmodule ComfyCouch.Database do
    @moduledoc """
        Database specfic calls
    """
    @doc false
    defmacro __using__(_opts) do
        quote do
            import ComfyCouch.Database
        end
    end

    @doc """
        open a db or create it if it doesn't exist.
        on :ok returns the name of the db
    """
    @spec use_or_create(string) :: {:ok, string} | {:error, Any}
    def use_or_create(name) do
        # Create the DB in Couch
        ComfyCouch.Couchdb.use_or_create_db(name)
    end

    @doc """
        Delete a given db
    """
    def delete!(name) do
        # Delete the DB in couch
        ComfyCouch.Couchdb.delete_db(name)
    end
end