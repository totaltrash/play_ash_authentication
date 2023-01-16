defmodule MyApp.Blog.Post do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "post"
    repo MyApp.Repo
  end

  actions do
    defaults([:read, :update, :destroy])

    create :create do
      primary? true
      argument :author_id, :uuid, allow_nil?: false
      change manage_relationship(:author_id, :author, type: :append_and_remove)
    end

    read :read_all do
      prepare build(load: [:author])
    end
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :created_at
    update_timestamp :updated_at
    attribute :title, :string, allow_nil?: false
  end

  relationships do
    belongs_to :author, MyApp.Accounts.User do
      api MyApp.Accounts
      allow_nil? false
    end
  end

  code_interface do
    define_for MyApp.Blog
    define :create, args: [:title, :author_id]
    define :read_all, action: :read_all
  end
end
