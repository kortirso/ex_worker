# ExWorker

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_worker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_worker, "~> 0.1.2"}
  ]
end
```

## Mnesia Setup

ExWorker runs out of the box, but by default all jobs are stored in-memory.
To persist jobs across application restarts, specify the DB path in your `config.exs`:

```elixir
config :mnesia, dir: 'mnesia/#{Mix.env}/#{node()}' # Notice the single quotes
```

And run the following mix task:

```bash
mix ex_worker.setup
```

This will create the Mnesia schema and job database for you. For a
detailed guide, see the [Mix Task Documentation][docs-mix]. For
compiled releases where `Mix` is not available
[see this][docs-setup-prod].

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_worker](https://hexdocs.pm/ex_worker).

