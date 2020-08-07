# Releasing

1. Update version file accordingly.
1. Run `bundle install` to update Gemfile.lock
1. Update `NEWS.md` to reflect the changes since last release.
1. Commit changes.
   There shouldn't be code changes,
   and thus CI doesn't need to run,
   you can then add "[ci skip]" to the commit message.
1. Push the new commit
1. Tag the release: `git tag -s vVERSION`
    - We recommend the [_quick guide on how to sign a commit_] from GitHub.
1. Push changes: `git push --tags`
1. Build and publish:
    ```bash
    gem build clearance.gemspec
    gem push clearance-*.gem
    ```
1. Add a new GitHub release using the recent `NEWS.md` as the content. Sample
   URL: https://github.com/thoughtbot/clearance/releases/new?tag=vVERSION
1. Announce the new release,
   making sure to say "thank you" to the contributors
   who helped shape this version!

[_quick guide on how to sign a commit_]: https://docs.github.com/en/github/authenticating-to-github/signing-commits
