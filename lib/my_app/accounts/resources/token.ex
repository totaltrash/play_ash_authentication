defmodule MyApp.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  postgres do
    table "user_token"
    repo MyApp.Repo
  end

  token do
    api MyApp.Accounts
  end
end
