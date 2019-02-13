# ExWorker

Simple example of message processing with Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_worker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_worker, "~> 0.1.4"}
  ]
end

def application do
  [
    extra_applications: [..., :ex_worker]
  ]
end
```

## Mnesia Setup

To persist messages across application restarts, specify the DB path in your `config.exs`:

```elixir
config :mnesia, dir: 'mnesia/#{Mix.env}/#{node()}' # Notice the single quotes
```

And run the following mix task:

```bash
mix ex_worker.setup
```

## Usage

```elixir
ExWorker.Server.add_message("some text")

ExWorker.Server.add_messages(["some text", "another text"])
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kortirso/ex_worker.

## License

The packages is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Disclaimer

Use this package at your own peril and risk.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_worker](https://hexdocs.pm/ex_worker).

