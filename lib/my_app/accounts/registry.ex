defmodule MyApp.Accounts.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry MyApp.Accounts.User
  end
end
