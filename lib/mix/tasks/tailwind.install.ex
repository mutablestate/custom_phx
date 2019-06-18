defmodule Mix.Tasks.Tailwind.Install do
  @shortdoc "Tailwindcss installer for Phoenix >= 1.4."

  @moduledoc """
  Install Tailwindcss in a new Phoenix project replacing Milligram.

  Provides the task

    mix tailwind.install
  """

  use Mix.Task

  @css_path "assets/css"
  @css [
    {:text, Path.join([@css_path, "app.css"]), Path.join([@css_path, "app.css"])},
    {:text, Path.join([@css_path, "phoenix.css"]), Path.join([@css_path, "phoenix.css"])},
    {:text, Path.join([@css_path, "tailwind.css"]), Path.join([@css_path, "tailwind.css"])},
    {:text, Path.join([@css_path, "custom", "alert.css"]), Path.join([@css_path, "custom", "alert.css"])},
    {:text, Path.join([@css_path, "custom", "base.css"]), Path.join([@css_path, "custom", "base.css"])}
  ]

  @assets_path "assets"
  @config [
    {:text, Path.join([@assets_path, "postcss.config.js"]), Path.join([@assets_path, "postcss.config.js"])},
    {:text, Path.join([@assets_path, "tailwind.config.js"]), Path.join([@assets_path, "tailwind.config.js"])},
    {:text, Path.join([@assets_path, "webpack.config.js"]), Path.join([@assets_path, "webpack.config.js"])}
  ]

  @templates [
    {:eex, "templates/layout/app.html.eex", Path.join(["lib", "base_name_web", "templates", "layout", "app.html.eex"])},
    {:eex, "templates/page/index.html.eex", Path.join(["lib", "base_name_web", "templates", "page", "index.html.eex"])}
  ]

  root = "priv/tailwind.install"
  all_files = @css ++ @config ++ @templates

  for {_, source, _} <- all_files do
    @external_resource Path.join(root, source)
    def render(unquote(source)), do: unquote(File.read!(Path.join(root, source)))
  end

  @doc false
  def run(_) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix tailwind.install can only be run inside an application directory")
    end

    if !System.find_executable("npm") do
      Mix.raise("mix tailwind.install cannot find npm executable")
    end

    Mix.shell().info("""
    Installing npm dev dependencies...

      * tailwindcss
      * postcss-loader
      * postcss-import
    """)

    System.cmd("npm", ["install", "-D", "tailwindcss", "postcss-loader", "postcss-import"], cd: "assets")

    Mix.shell().info("""
    Copying asset config files...

      * postcss.config.js
      * tailwind.config.js
      * webpack.config.js
    """)

    files = @config
    copy_files(files, base: base_module())

    Mix.shell().info("""
    Copying asset css files...

      * app.css
      * phoenix.css
      * tailwind.css
      * custom/alert.css
      * custom/base.css
    """)

    files = @css
    copy_files(files, base: base_module())

    Mix.shell().info("""
    Copying template eex files...

      * layout/app.html.eex
      * page/index.html.eex
    """)

    files = @templates
    copy_files(files, [])

    Mix.shell().info("""
    You're all set!
    """)
  end

  defp copy_files(files, opts) do
    for {format, source, target} <- files do
      target =
        target
        |> String.replace("base_name", base_name())

      contents =
        case format do
          :text -> render(source)
          :eex -> EEx.eval_string(render(source), opts)
        end

      Mix.Generator.create_file(target, contents)
    end
  end

  defp base_module do
    base_name() |> Macro.camelize()
  end

  defp base_name do
    Mix.Project.config() |> Keyword.fetch!(:app) |> to_string
  end
end
