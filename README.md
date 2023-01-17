# Playing with Phoenix 1.7.0-rc, LiveView 0.18 and Ash Authentication

Like it says, let's kick off a new Phoenix application, and try out some new stuff.

* Phoenix 1.7 comes with some new stuff. Verified routes and unifying the Phoenix dead view templates and layout handling with LiveView are the big ticket items.
* Declarative assigns and slots in LiveView 0.18
* And something I'm so excited to try - Ash Authentication. I've used Ash for a couple of years now, and always hand rolled my own auth solution (with the help of the phx-gen-auth and the archived [example_with_auth](https://github.com/ash-project/example_with_auth))

This project will also use Wallaby to end-to-end test flows around authentication.

Let's walk through the building of a blog and discover some of the new features:

## Initial commit f2183dc

Install the phoenix installer rc: `mix archive.install hex phx_new 1.7.0-rc.2`

Check the currently installed version `mix phx.new -v`

Create a new application `mix phx.new my_app`

I'm going to run with the Phoenix installation as is, keeping the installed core components, and using verified routes and other new goodies.

## Install Wallaby b00c287

Install Wallaby as per its doco, with a FeatureCase and a feature to verify the installation

## Install Ash 8d3e5b2

Install Ash, AshPostgres and added a couple resources to implement a simple blog.

Set up a LiveView to display the posts, and a Wallaby feature to test this.

## Refactor UI and write first authentication tests

Tweak the UI to display the blog posts on the home page (available to public), and an admin backend (which should be available to logged in users only).

Write some Wallaby features to verify the above. We haven't installed Ash Authentication yet so the test asserting that a user accessing an admin page who is not logged in will fail. But some tests to drive development and verify my expectations is always nice.

Tweak the page_controller_test to pass (although it is redundant as we're covering this feature with a Wallaby test).
