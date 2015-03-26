Comfycouch
==========

A simple CouchDB client for Elixir.

This is a work in progress... See the tests for examples of use.

A sidenote, this project started as a metaprogramming project inspired by Amnesia.
Initially, I created some macros to make a little DSL for a couch client:

```
  defdatabase Blog do
    defdocument Posts, [:title, :date] do
      def list do
       ...
      end
    end
  end
```

This quickly became harder than it needed to be, so I settled on the lazy approach:

``` 
  {:ok, _} = Database.use_or_create("sampledb")
  d0 = %{name: "dave", posts: [1,2,3]}  
  doc0 = d0 |> Document.save
```

