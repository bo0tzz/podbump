defmodule Podbump do
  require Logger

  def is_latest_image(pod) do
    %{image: image, digest: current_digest} = Podbump.Kubernetes.current_image(pod)
    {:ok, latest_digest} = Podbump.Registry.latest_digest(image)

    current_digest == latest_digest
  end

  def run() do
    pods = Podbump.Kubernetes.get_all()

    Logger.info("Podbump is evaluating #{Enum.count(pods)} pods")

    Task.async_stream(pods, fn pod ->
      name = pod["metadata"]["name"]

      if not is_latest_image(pod) do
        Logger.warn("Pod #{name} is running an outdated image - deleting it")
        Podbump.Kubernetes.delete_pod(pod)
      end

      :ok
    end)
    # Consume the stream so it runs
    |> Enum.to_list()
  end
end
