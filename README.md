# CustomPhx

Mix tasks to help customise a newly generated Phoenix app.

## Requirements

Requires Phoenix 1.4 or above (configured with webpack).

```sh
mix phx.new --version
Phoenix v1.4.8
```

## Usage

1. Install the `custom_phx` archive (adds new mix tasks).

```sh
mix archive.install https://github.com/mutablestate/custom_phx/raw/master/archives/custom_phx.ez
```

2. Create a new Phoenix project (tested with default options).

```sh
mix phx.new APP_NAME

Fetch and install dependencies? [Yn] y

cd APP_NAME
```

3. Install Tailwindcss (config, templates, HTML generator task).

```sh
mix tailwind.install
```

4. (optional) Run the Tailwindcss HTML generator (instead of `mix phx.gen.html`).

```sh
mix tailwind.gen.html Accounts User users name:string email:string
```

## License

[MIT](LICENSE.md)
