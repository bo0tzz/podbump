import Config

get_k8s_conn = fn ->
  {m, f, a} = Application.fetch_env!(:podbump, Podbump.Kubernetes)[:conn_args]

  case apply(m, f, a) do
    {:ok, conn} -> conn
    {:error, err} -> raise "Failed to load kubernetes configuration: #{inspect(err)}"
  end
end

config :podbump, Podbump.Kubernetes, conn: get_k8s_conn.()
