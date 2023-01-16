defmodule Test.Factory do
  alias MyApp.{Accounts, Blog}

  def insert_user(attr \\ []) do
    attr =
      Enum.into(attr, %{
        username: "someuser",
        name: "Some User"
      })

    Accounts.User.create!(attr.username, attr.name)
  end

  def insert_post(attr \\ []) do
    attr =
      Enum.into(attr, %{
        title: "A Blog Post Title"
      })

    Blog.Post.create!(attr.title, attr.author.id)
  end
end
