# Elixir Extension server for [RESP.app](https://resp.app/)

## DEPRECATION NOTICE

Resp.app doesn't exist anymore and Redist Insights doesn't support this type of extensions 

## About
You may want to use it if you work with libraries like 
[nebulex_redis_adapter](https://github.com/cabol/nebulex_redis_adapter)
or [redbird](https://github.com/thoughtbot/redbird)
which store elixir terms to redis in binary format.

This server adds `Elixir terms` formatter, so you can view and edit such record values.

## Usage

Simply download server.exs file and run
```
$ elixir server.exs
```
The server is accessible at `http://localhost:8000`.
