# CustomPhx

Mix tasks to help customise a newly generated Phoenix app.

## Usage

Requires Phoenix 1.4 or above (configured with webpack).

```
mix phx.new --version
Phoenix v1.4.8
```

Install the `custom_phx` archive to add new mix tasks.

```
mix archive.install https://github.com/mutablestate/custom_phx/raw/master/archives/custom_phx.ez
```

Create a new Phoenix project with default options.

```
mix phx.new APP_NAME

Fetch and install dependenciews? [Yn] y

cd APP_NAME
```

## Mix Tasks

Replace Milligram with Tailwindcss.

```
mix tailwind.install
```

## Copyright and License

[MIT License](LICENSE.md).
