defmodule MyApp.Accounts.User do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "user_account"
    repo MyApp.Repo
  end

  actions do
    defaults([:create, :read, :update, :destroy])
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :created_at
    update_timestamp :updated_at
    attribute :username, :string, allow_nil?: false
    attribute :name, :string, allow_nil?: false
  end

  relationships do
    has_many :posts, MyApp.Blog.Post do
      api MyApp.Blog
      destination_attribute :author_id
    end
  end

  code_interface do
    define_for MyApp.Accounts
    define :create, args: [:username, :name]
    define :read
  end
end
