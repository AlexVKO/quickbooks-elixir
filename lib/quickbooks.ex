defmodule Quickbooks do
  @moduledoc """
  An HTTP client for Quickbooks.
  """
  use Application

  def start(_type, _args) do
    Quickbooks.Supervisor.start_link
  end

  def oauth_consumer_key do
    Application.get_env(:quickbooks, :oauth_consumer_key)
  end

  def oauth_consumer_secret do
    Application.get_env(:quickbooks, :oauth_consumer_secret)
  end

  def oauth_callback_url do
    Application.get_env(:quickbooks, :oauth_callback_url)
  end

  def sandbox? do
    Application.get_env(:quickbooks, :sandbox)
  end

end
