defmodule Podbump.Registry do
  @doc """
  Get the latest digest for a given image and tag in this registry.
  """
  @callback latest_digest(image :: String.t(), tag :: String.t()) ::
              {:ok, String.t()} | {:error, String.t()}

  @doc """
  Get the behaviour implementation for a registry domain
  """
  def impl_for("ghcr.io"), do: Podbump.Registry.Github
  def impl_for(reg), do: raise("Registry #{reg} is not supported")

  @doc """
  Get the latest digest for an image address
  """
  def latest_digest(image_address) do
    [registry_domain, image_tag] = String.split(image_address, "/", parts: 2)
    reg = impl_for(registry_domain)

    [image, tag] = String.split(image_tag, ":")
    reg.latest_digest(image, tag)
  end
end
