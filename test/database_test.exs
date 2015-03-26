


defmodule DatabaseTest do
    use ExUnit.Case
    alias ComfyCouch.Database

    @db "comfycouch_testdb"

    setup_all do
        ComfyCouch.start
        Database.delete!(@db)
        :ok 
    end

    test "db creation works" do
        {:ok, r} = Database.use_or_create(@db)
        assert r == @db
    end

    test "returns server info" do
        {:ok, r} = ComfyCouch.server_info
        assert r["couchdb"] == "Welcome"
    end
    
end