defmodule ExWorker.MixProject do
  use Mix.Project

  @description """
    Messages processing with Elixir
  """

  def project do
    [
      app: :ex_worker,
      version: "0.1.3",
      elixir: "~> 1.7",
      name: "I18nParser",
      description: @description,
      source_url: "https://github.com/kortirso/ex_worker",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      mod: {ExWorker, []},
      extra_applications: [:logger, :memento]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev},
      {:memento, "~> 0.2.1"}
    ]
  end

  defp package do
    [
      maintainers: ["Anton Bogdanov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kortirso/ex_worker"}
    ]
  end
end
