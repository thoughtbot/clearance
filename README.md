# Clearance (Codename: Super Monban)

This is an exploration of one way forward for Clearance in its next major
release. This represents a re-write of Clearance to sit atop the Monban, which
in turn sits atop Warden.

The idea is that Clearance would be an opinionated Rails engine but would no
longer directly concern itself with the lower levels of authentication.

## Breaking Changes

If this ever sees the light of day, it will be as a new major-version release of
Clearance and thus breaking changes are fair game. We will try to be discerning
about the breaking changes introduced but if Clearance is better for the change,
we will make it. Here is a list of breaking changes we know of so far:

* `UsersController` is now `SignUpsController`. This change keeps Clearance
  routes from stepping on potentially useful application routes and also allows
  for changing the resource name or plurality without having an odd disconnect
  in routes.
* Resourceful routes are gone. Every Clearance route will have a "vanity" route.
  In Clearance 1.x you could redirect to `new_session_path` or `sign_in_path`
  and get the same result. Now there is but one way to get to sign in:
  `sign_in_path`.
* `users#url_after_create` is now `sign_ups#url_after_sign_up`. This is also now
  exposed via the `url_after_sign_up` configuration.
* `sessions#url_after_create` is now `sessions#url_after_sign_in` and is also
  exposed via the `url_after_sign_in` configuration.
* `sessions#url_after_destroy` is now `sessions#url_after_sign_out` and is also
  exposed via the `url_after_sign_out` configuration.
