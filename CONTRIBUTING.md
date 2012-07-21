We love pull requests. Here's a quick guide:

1. Fork the repo.

2. Set up Appraisal, which helps us test against multiple Rails versions:
   `rake appraisal:install`.

3. Run the tests. We only take pull requests with passing tests, and it's great
   to know that you have a clean slate: `rake`

4. Add a test for your change. Only refactoring and documentation changes
   require no new tests. If you are adding functionality or fixing a bug, we need
   a test!

5. Make the test pass.

6. Push to your fork and submit a pull request.

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within three business days (and, typically, one business
day). We may suggest some changes or improvements or alternatives.

Some things that will increase the chance that your pull request is accepted,
taken straight from the Ruby on Rails guide:

* Use Rails idioms and helpers
* Include tests that fail without your code, and pass with it
* Update the documentation, the surrounding one, examples elsewhere, guides,
  whatever is affected by your contribution
