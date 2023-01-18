defmodule MyApp.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  postgres do
    table "user_account"
    repo MyApp.Repo
  end

  authentication do
    api MyApp.Accounts

    strategies do
      password :password do
        identity_field :username
      end
    end

    tokens do
      enabled? true
      token_resource MyApp.Accounts.Token

      signing_secret fn _, _ ->
        {:ok, Application.fetch_env!(:my_app, MyAppWeb.Endpoint)[:secret_key_base]}
      end
    end
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:hashed_password]
      argument :password, :string, sensitive?: true
      change set_context(%{strategy_name: :password})
      change AshAuthentication.Strategy.Password.HashPasswordChange
    end

    # Playing with a custom implementation of the register_with_password action that ships with ash_authentication_phoenix
    # create :register_with_password do
    #   allow_nil_input [:hashed_password]

    #   argument :password, :string, sensitive?: true
    #   argument :password_confirmation, :string, sensitive?: true

    #   change AshAuthentication.Strategy.Password.HashPasswordChange
    #   change AshAuthentication.GenerateTokenChange
    #   validate AshAuthentication.Strategy.Password.PasswordConfirmationValidation
    # end
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :created_at
    update_timestamp :updated_at
    attribute :username, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
    attribute :name, :string, allow_nil?: false
  end

  relationships do
    has_many :posts, MyApp.Blog.Post do
      api MyApp.Blog
      destination_attribute :author_id
    end
  end

  identities do
    identity :unique_username, [:username]
  end

  code_interface do
    define_for MyApp.Accounts
    define :create, args: [:username, :password, :name]
    define :read
  end
end
