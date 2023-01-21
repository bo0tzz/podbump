import Config

get_k8s_conn = fn ->
  {m, f, a} = Application.fetch_env!(:podbump, Podbump.Kubernetes)[:conn_args]

  {:ok, conn} = apply(m, f, a)
  conn
end

config :podbump, Podbump.Kubernetes, conn: get_k8s_conn.()
