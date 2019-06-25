defmodule Mix.Tasks.Tailwind.Install do
  @shortdoc "Tailwindcss installer for Phoenix >= 1.4."

  @moduledoc """
  Install Tailwindcss in a new Phoenix project replacing Milligram.

  Provides task

    mix tailwind.install
  """

  use Mix.Task

  @css_path "assets/css"
  @css [
    {:text, Path.join([@css_path, "app.css"]), Path.join([@css_path, "app.css"])},
    {:text, Path.join([@css_path, "base.css"]), Path.join([@css_path, "base.css"])},
    {:text, Path.join([@css_path, "phoenix.css"]), Path.join([@css_path, "phoenix.css"])},
    {:text, Path.join([@css_path, "tailwind.css"]), Path.join([@css_path, "tailwind.css"])},
    {:text, Path.join([@css_path, "blocks", "alert.css"]), Path.join([@css_path, "blocks", "alert.css"])},
    {:text, Path.join([@css_path, "blocks", "btn.css"]), Path.join([@css_path, "blocks", "btn.css"])},
    {:text, Path.join([@css_path, "blocks", "table.css"]), Path.join([@css_path, "blocks", "table.css"])}
  ]

  @assets_path "assets"
  @config [
    {:text, Path.join([@assets_path, "postcss.config.js"]), Path.join([@assets_path, "postcss.config.js"])},
    {:text, Path.join([@assets_path, "tailwind.config.js"]), Path.join([@assets_path, "tailwind.config.js"])},
    {:text, Path.join([@assets_path, "webpack.config.js"]), Path.join([@assets_path, "webpack.config.js"])}
  ]

  @web_templates [
    {:eex, "templates/layout/app.html.eex", Path.join(["lib", "base_name_web", "templates", "layout", "app.html.eex"])},
    {:eex, "templates/page/index.html.eex", Path.join(["lib", "base_name_web", "templates", "page", "index.html.eex"])}
  ]

  @gen_path "priv/templates/tailwind.gen.html"
  @gen_templates [
    {:text, Path.join([@gen_path, "controller_test.exs"]), Path.join([@gen_path, "controller_test.exs"])},
    {:text, Path.join([@gen_path, "controller.ex"]), Path.join([@gen_path, "controller.ex"])},
    {:text, Path.join([@gen_path, "edit.html.eex"]), Path.join([@gen_path, "edit.html.eex"])},
    {:text, Path.join([@gen_path, "form.html.eex"]), Path.join([@gen_path, "form.html.eex"])},
    {:text, Path.join([@gen_path, "index.html.eex"]), Path.join([@gen_path, "index.html.eex"])},
    {:text, Path.join([@gen_path, "new.html.eex"]), Path.join([@gen_path, "new.html.eex"])},
    {:text, Path.join([@gen_path, "show.html.eex"]), Path.join([@gen_path, "show.html.eex"])},
    {:text, Path.join([@gen_path, "view.ex"]), Path.join([@gen_path, "view.ex"])}
  ]

  @mix_tasks_path "lib/base_name/mix/tasks"
  @mix_tasks [
    {:text, "mix/tasks/tailwind.gen.html.ex", Path.join([@mix_tasks_path, "tailwind.gen.html.ex"])}
  ]

  root = "priv/tailwind.install"
  all_files = @css ++ @config ++ @web_templates ++ @gen_templates ++ @mix_tasks

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

     * Installing npm dev dependencies...
    """)

    System.cmd("npm", ["install", "-D", "tailwindcss", "@tailwindcss/custom-forms", "postcss-loader", "postcss-import"],
      cd: "assets"
    )

    copy_steps = [
      %{files: @config, msg: "config assets", base: base_module()},
      %{files: @css, msg: "css assets", base: base_module()},
      %{files: @web_templates, msg: "web templates", base: []},
      %{files: @gen_templates, msg: "priv templates", base: []},
      %{files: @mix_tasks, msg: "mix tasks", base: []}
    ]

    for step <- copy_steps, do: copy_files_with_msg(step)

    Mix.shell().info("""

    Successfully installed Tailwindcss!

      New mix task added:

        mix tailwind.gen.html
        # Generates controller, Tailwindcss styled views, and context for an HTML resource
    """)
  end

  defp copy_files_with_msg(%{files: files, msg: msg, base: base}) do
    Mix.shell().info("""

      Copying #{msg}...
    """)

    copy_files(files, base: base)
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
