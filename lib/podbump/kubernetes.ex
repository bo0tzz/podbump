defmodule Podbump.Kubernetes do
  defp conn() do
    Application.fetch_env!(:podbump, __MODULE__)[:conn]
  end

  def get_all() do
    op =
      K8s.Client.list("v1", "Pod")
      |> K8s.Selector.label({"podbump.bo0tzz.me/enabled", "true"})

    {:ok, %{"items" => pods}} = K8s.Client.run(conn(), op)

    pods
  end

  def delete_pod(pod) do
    op =
      K8s.Client.delete("v1", "Pod",
        namespace: K8s.Resource.namespace(pod),
        name: K8s.Resource.name(pod)
      )

    {:ok, _res} = K8s.Client.run(conn(), op)
  end

  def current_image(pod) do
    container_status = get_in(pod, ["status", "containerStatuses", Access.at(0)])

    image = container_status["image"]
    [_, digest] = container_status["imageID"] |> String.split("@")

    %{image: image, digest: digest}
  end
end
