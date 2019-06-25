defmodule CustomPhx.MixProject do
  use Mix.Project

  def project do
    [
      app: :custom_phx,
      version: version(),
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def version, do: "0.0.2"

  defp build_releases(_) do
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run([])
    Mix.Tasks.Archive.Build.run(["--output=custom_phx.ez"])
    File.rename("custom_phx.ez", "./archives/custom_phx.ez")
    File.rename("custom_phx-#{version()}.ez", "./archives/custom_phx-#{version()}.ez")
  end

  defp aliases do
    [
      build: [&build_releases/1]
    ]
  end
end
