defmodule MyApp.Blog.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry MyApp.Blog.Post
  end
end
