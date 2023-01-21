defmodule Podbump.MixProject do
  use Mix.Project

  def project do
    [
      app: :podbump,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Podbump.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:k8s, "~> 1.2"},
      {:quantum, "~> 3.5"},
      {:tesla, "~> 1.5"},
      {:jason, "~> 1.4"}
    ]
  end
end
