# Nicole Birthday Poll

LiveView-powered realtime poll for deciding Nicole's birthday plans. The app focuses on a single poll at a time, keeping results in sync across every open session.

## Features

- Realtime vote updates over Phoenix PubSub
- Limited vote changes (default: 3 per session)
- Totals and percentage breakdown per option

## Tech stack

- Elixir + Phoenix 1.8 + LiveView
- Postgres (Ecto)
- Tailwind CSS v4 + esbuild

## Local development

Prerequisites:

- Elixir 1.15+
- Postgres

Setup:

1. `mix setup`
2. `mix phx.server`
3. Visit `http://localhost:4000`

Database configuration defaults to the local `postgres` user. Override with
`POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_HOST` as needed.

## Seeds

Load the sample poll with:

```sh
mix run priv/repo/seeds.exs
```

## Tests and quality

- `mix test`
- `mix format`
- `mix precommit`
