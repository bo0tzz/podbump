import Config

if config_env() == :prod do
  config :podbump, Podbump.Kubernetes, conn_args: {K8s.Conn, :from_service_account, []}
end

if config_env() == :dev do
  config :podbump, Podbump.Kubernetes,
    conn_args: {K8s.Conn, :from_file, ["/Users/boet/.kube/config", [context: "immich-preview"]]}
end
