defmodule Quickbooks.AccountingAPI.CustomerQBO do
  use HTTPoison.Base
  @doc """
    Accounting api wrapper for Customer
  """

  def query(credentials, query \\ "SELECT+*+FROM+Customer+STARTPOSITION+1+MAXRESULTS+20") do
    Quickbooks.AccountingAPI.query(credentials, query)
  end

  def base_url do
    "https://sandbox-quickbooks.api.intuit.com/v3/company"
  end
end
