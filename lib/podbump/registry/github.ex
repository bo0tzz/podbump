defmodule Podbump.Registry.Github do
  @behaviour Podbump.Registry
  use Tesla

  require Logger

  plug(Tesla.Middleware.BaseUrl, "https://ghcr.io")
  plug(Tesla.Middleware.JSON)
  plug Tesla.Middleware.Headers, [{"Accept", "application/vnd.oci.image.index.v1+json"}]

  @impl true
  def latest_digest(image, tag) do
    with {:ok, token} <- get_token(image),
         headers <- [{"Authorization", "Bearer #{token}"}],
         {:ok, %{status: 200, headers: headers}} <-
           head("/v2/#{image}/manifests/#{tag}", headers: headers),
         {"docker-content-digest", digest} <- List.keyfind!(headers, "docker-content-digest", 0) do
      {:ok, digest}
    else
      {:ok, %Tesla.Env{status: status, body: body}} ->
        Logger.warn("Github api error #{status}: #{inspect(body)}")
        {:error, :github_error}

      {:error, err} ->
        {:error, err}
    end
  end

  defp get_token(image) do
    with {:ok, %{status: 200, body: %{"token" => token}}} <-
           get("/token?scope=repository:#{image}:pull") do
      {:ok, token}
    else
      {:ok, %Tesla.Env{status: status, body: body}} ->
        Logger.warn("Github api error #{status}: #{inspect(body)}")
        {:error, :github_error}

      {:error, err} ->
        {:error, err}
    end
  end
end
