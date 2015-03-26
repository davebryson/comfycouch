

defmodule CrudTest do 
    use ExUnit.Case
    alias ComfyCouch.Database
    alias ComfyCouch.Document

    @db "comfycouch_testdb"

    setup_all do
        ComfyCouch.start
        Database.delete!(@db)
        {:ok, _} = Database.use_or_create(@db)
        :ok
    end

    test "create document" do
        # Show using a map
        d0 = %{name: "dave", posts: [1,2,3]}  
        doc0 = d0 |> Document.save
        
        refute doc0.id == nil
        refute doc0.rev == nil
        assert doc0.name == "dave"
        assert length(doc0.posts) == 3
        assert [1,2,3] == doc0.posts

        # Show using keywords
        d1 = [name: "bob", age: 50, posts: [1,2,3], type: "season"]
        doc1 = d1 |> Document.save

        refute doc1.id == nil
        refute doc1.rev == nil
        assert doc1.name == "bob"
        assert doc1.type == "season"
    end

    test "update a doc" do
        d0 = %{name: "dave", language: "python"}  
        doc0 = d0 |> Document.save
        refute doc0.id == nil
        refute doc0.rev == nil
        assert doc0.language == "python"
        
        doc2 = %{doc0 | language: "Elixir"} |> Document.save
        refute doc2.id == nil
        assert doc0.id == doc2.id
        assert doc2.language == "Elixir"
    end

    test "read a doc by ID" do
        d0 = %{id: "sample", name: "carl", language: "python"}  
        doc0 = d0 |> Document.save
        refute doc0.id == nil
        refute doc0.rev == nil
        assert doc0.language == "python"

        d1 =  Document.get("sample")
        refute doc0.id == nil
        refute doc0.rev == nil
        assert d1.rev == doc0.rev
        assert d1.language == "python"
    end

    test "delete a doc" do
        d0 = %{id: "sample2", name: "carly", language: "python"}  
        doc0 = d0 |> Document.save
        refute doc0.id == nil
        refute doc0.rev == nil
        assert doc0.language == "python"

        {:ok, _} = Document.delete(doc0.id, doc0.rev)
    end

end