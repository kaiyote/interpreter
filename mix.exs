defmodule Interpreter.Mixfile do
  @moduledoc false

  use Mix.Project

  def project do
    [app: :interpreter,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     dialyzer: [plt_add_apps: [:mix]],

     # Docs
     name: "Interpreter",
     source_url: "https://github.com/kaiyote/interpreter",
     docs: [main: "Interpreter",
            extras: ["README.md"]]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:credo, only: [:dev, :test], git: "https://github.com/rrrene/credo.git"},
     {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
     {:ex_doc, "~> 0.14", only: [:dev], runtime: false}]
  end
end
