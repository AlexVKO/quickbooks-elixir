defmodule Quickbooks do
  @moduledoc """
  An HTTP client for Quickbooks.
  """
  use Application

  def start(_type, _args) do
    Quickbooks.Supervisor.start_link
  end

  def client_id do
    Application.get_env(:quickbooks, :client_id)
  end

  def client_secret do
    Application.get_env(:quickbooks, :client_secret)
  end

  def oauth_callback_url do
    Application.get_env(:quickbooks, :oauth_callback_url)
  end

  def sandbox? do
    Application.get_env(:quickbooks, :sandbox)
  end

end
