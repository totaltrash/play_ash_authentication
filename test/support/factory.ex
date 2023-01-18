defmodule Test.Factory do
  alias MyApp.{Accounts, Blog}

  def insert_user(attr \\ []) do
    attr =
      build_attr(attr,
        username: "someuser",
        password: "password",
        name: "Some User"
      )

    Accounts.User.create!(attr.username, attr.password, attr.name)
  end

  def insert_post(attr \\ []) do
    attr =
      build_attr(attr,
        title: "A Blog Post Title",
        author: [required: true]
      )

    Blog.Post.create!(attr.title, attr.author.id)
  end

  defp build_attr(attr, schema) do
    # playing with a new approach to set attributes on a factory, and setting defaults where appropriate:
    #   * attrs are provided as a keyword list
    #   * the schema for the attrs is defined in schema (similar to NimbleOptions schema, but with the following extras)
    #     - if the value for the schema item is a string, that is the default to use
    #     - if it is a list, treat it as a NimbleOption (so you can mark it as required in the schema)
    #     - if there is an item in the attr that is not represented in the schema, then that's ok (we'll add it to the schema)

    # add extra attr keys to the schema (will be default NimbleOption, ie not required, any type)
    schema =
      for {attr_key, _} <- attr, reduce: schema do
        acc ->
          case Keyword.has_key?(schema, attr_key) do
            true -> acc
            _ -> [{attr_key, []} | acc]
          end
      end

    # normalize the schema values, converting strings to lists, setting the default
    schema =
      Enum.map(schema, fn schema_item ->
        case schema_item do
          {key, default} when is_binary(default) ->
            {key, [default: default]}

          other ->
            other
        end
      end)

    # validate and convert to a map
    attr
    |> NimbleOptions.validate!(schema)
    |> Enum.into(%{})
  end
end
