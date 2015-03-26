defmodule Comfycouch.Mixfile do
  use Mix.Project

  @description """
    An simple Elixir client for CouchDb based on Couchbeam.
  """

  def project do
    [app: :comfycouch,
     version: "0.0.1",
     elixir: "~> 1.0",
     name: "ComfyCouch",
     description: @description,
     deps: deps,
     package: package
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:couchbeam, git: "https://github.com/benoitc/couchbeam.git", tag: "1.1.7"}
    ]
  end

  defp package do
    [ contributors: ["Dave Bryson"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/davebryson/comfycouch"} 
    ]
  end

end
