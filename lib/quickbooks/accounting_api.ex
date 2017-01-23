defmodule Quickbooks.AccountingAPI do
  @moduledoc """
    Wrapper to handle with Accounting API
    https://developer.intuit.com/docs/api/accounting
  """
  import Quickbooks.Request.Base

  @sandbox_url     "https://sandbox-quickbooks.api.intuit.com/v3/company"
  @production_url  "https://quickbooks.api.intuit.com/v3/company"

  @doc """
    Method to QUERY end point

    https://developer.intuit.com/docs/0100_quickbooks_online/0200_dev_guides/accounting/querying_data

    returns status and decoded body
  """
  def query(%{token: token, token_secret: token_secret, realm_id: realm_id}, query) do
    %Quickbooks.Request{}
    |> build_headers
    |> build_qbo_url(base_url() , realm_id, "query")
    |> add_query_params(query)
    |> add_verb("get")
    |> Quickbooks.OAuthQBO.oauth_sign_request(token, token_secret)
    |> execute
  end

  @doc """
    returns status and decoded body
  """
  def create() do end

  @doc """
    returns status and decoded body
  """
  def update() do end

  @doc """
    returns status and decoded body
  """
  def get   () do end

  @doc """
    returns status and decoded body
  """
  def delete() do end

  @doc """
    Defines what base url is, based on `sandbox` params on configuration
  """
  defp base_url do
    @sandbox_url
  end
end
