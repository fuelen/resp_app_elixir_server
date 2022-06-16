Mix.install([
  {:plug_cowboy, "~> 2.0"},
  {:jason, "~> 1.3"}
])

defmodule Server do
  use Plug.Router
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/data-formatters" do
    json(conn, [%{id: "elixir-term", name: "Elixir terms", "read-only": false}])
  end

  post "data-formatters/elixir-term/decode" do
    output =
      conn.params["data"]
      |> Base.decode64!()
      |> :erlang.binary_to_term()
      |> inspect(pretty: true)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, output)
  end

  post "data-formatters/elixir-term/encode" do
    data = Base.decode64!(conn.params["data"])

    case Code.string_to_quoted(data) do
      {:ok, quoted} ->
        try do
          output =
            quoted
            |> Code.eval_quoted()
            |> elem(0)
            |> :erlang.term_to_binary()

          conn
          |> put_resp_content_type("application/octet-stream")
          |> send_resp(200, output)
        rescue
          error -> json(conn, 400, %{error: Exception.message(error)})
        end

      {:error, {location, error, token}} ->
        json(conn, 400, %{error: inspect(location) <> ": " <> error <> " " <> inspect(token)})
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp json(conn, status \\ 200, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end

Plug.Cowboy.http(Server, [], port: 8000)
System.no_halt(true)
