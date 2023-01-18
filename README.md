# Playing with Phoenix 1.7.0-rc, LiveView 0.18 and Ash Authentication

Like it says, let's kick off a new Phoenix application, and try out some new stuff.

* Phoenix 1.7 comes with some new stuff. Verified routes and unifying the Phoenix dead view templates and layout handling with LiveView are the big ticket items.
* Declarative assigns and slots in LiveView 0.18
* And something I'm so excited to try - Ash Authentication. I've used Ash for a couple of years now, and always hand rolled my own auth solution (with the help of the phx-gen-auth and the archived [example_with_auth](https://github.com/ash-project/example_with_auth))

This project will also use Wallaby to end-to-end test flows around authentication.

Let's walk through the building of a blog and discover some of the new features:

## Initial commit [f2183dc](https://github.com/totaltrash/play_ash_authentication/commit/f2183dc3445e6393d2ce734bce35d774e9e5d8ae)

Install the phoenix installer rc: `mix archive.install hex phx_new 1.7.0-rc.2`

Check the currently installed version `mix phx.new -v`

Create a new application `mix phx.new my_app`

I'm going to run with the Phoenix installation as is, keeping the installed core components, and using verified routes and other new goodies.

## Install Wallaby [b00c287](https://github.com/totaltrash/play_ash_authentication/commit/b00c287caea5521ad1d8d3d4d353bffb55a11fce)

Install Wallaby as per its doco, with a FeatureCase and a feature to verify the installation

## Install Ash [8d3e5b2](https://github.com/totaltrash/play_ash_authentication/commit/8d3e5b235c4f5f58eb28014a6992b6cae1a72e14)

Install Ash, AshPostgres and added a couple resources to model a simple blog (a post resource, a user resource and relate the two so a post has an author).

Set up a LiveView to display the posts, and a Wallaby feature to test this.

## Refactor UI and write first authentication tests [f96491a](https://github.com/totaltrash/play_ash_authentication/commit/f96491ae53bea2fe1565725804eae82cd1327de1)

Tweak the UI to display the blog posts on the home page (available to public), and an admin backend (which should be available to logged in users only).

Write some Wallaby features to verify the above. We haven't installed Ash Authentication yet so the test asserting that a user accessing an admin page who is not logged in will fail. But some tests to drive development and verify my expectations is always nice.

Tweak the page_controller_test to pass (although it is redundant as we're covering this feature with a Wallaby test).

## Install Ash Authentication

Our aim here is to install Ash Authentication and have the failing test from the previous commit pass - which should just require a plug to look for a current user for the admin route.

Install Ash Authentication, which comes in two parts, the core `ash_authentication`, and `ash_authentication_phoenix` - the latter has helpers for if you're running Phoenix. See the [ash_authentication](https://ash-hq.org/docs/guides/ash_authentication/latest/tutorials/getting-started-with-authentication) and [ash_authentication_phoenix ](https://ash-hq.org/docs/guides/ash_authentication/latest/integrating-ash-authentication-and-phoenix) on ash-hq

Modify the user resource and create a user_token, as per the doco. I'll use the username in the existing user resource as the identity for authentication (rather than email). Add a create action that will be used for tests or could be used as the implementation in an app where user access is controlled by a system owner (rather than self registration).

Moving over to the the web side, update the router and create the auth controller as per the doco.

Generate a migration and migrate.

In addition to the documentation, I needed to set `use Phoenix.Router, helpers: true` in my_app_web.ex (ash_authentication_phoenix is using the helper for route generation). I also borrowed AuthController.failure from [ash-hq](https://github.com/ash-project/ash_hq/blob/main/lib/ash_hq_web/controllers/auth_controller.ex)

Set up a new pipeline in the router for `require_authenticated_user` and added authentication helpers and plugs to an Authentication module.

Modify test factory to suit the updated user.

Now my failing test case passes - when an unauthenticated user hits the protected route, they are redirected to the login.

Next, we'll flesh out the test cases for logging in and self registration, and then work on the implementation.
