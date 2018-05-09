
# Heroku Memory Capitulator

Restart your Heroku application based on Heroku errors (e.g R14) indicating
the app is in dire need of a restart.

- [Environment variables](#environment-variables)
- [Contents](#contents)
  - [Base system](#base-system)
  - [General](#general)
  - [Frontend](#frontend)
  - [Development](#development)
  - [Test](#test)
  - [Production](#production)
- [Removed](#removed)
- [Notes](#notes)
  - [Webpacker, the asset pipeline, and ES6](#webpacker--the-asset-pipeline--and-es6)
  - [Custom classes](#custom-classes)
  - [Gemfile.dev / Gemfile.dev.lock](#gemfiledev---gemfiledevlock)
  - [`Rack::RejectTrace` middleware](#rack--rejecttrace-middleware)
  - [Favicons](#favicons)

## Environment variables

| Variable              | Comment                                                                 |
|-----------------------|-------------------------------------------------------------------------|
| AIRBRAKE_PROJECT_ID   | Used in `config/initializers/airbrake.rb`                               |
| AIRBRAKE_API_KEY      | Used in `config/initializers/airbrake.rb`                               |
| BLOCK_HTTP_TRACE      | Disables HTTP `TRACE` method if set to true/t/1                         |
| BUNDLE_GEMFILE        | Useful when using a [Gemfile.dev](#gemfiledev---gemfiledevlock)         |
| DATABASE_URL          | Used for `production` env, automatically set by Heroku                  |
| GOOGLE_ANALYTICS_ID   | Will be added to the main application layout if set                     |
| HOST                  | Your base URI, e.g. https://myapp.herokuapp.com                         |
| NEW_RELIC_APP_NAME    | Used in `config/newrelic.yml`                                           |
| NEW_RELIC_LICENSE_KEY | Used in `config/newrelic.yml`                                           |
| PORT                  | Port Puma will listen on, defaults to 3000                              |
| RAILS_LOG_TO_STDOUT   | Set by Heroku Ruby buildpack, set manually on other platforms if needed |
| RAILS_MAX_THREADS     | Number of Puma threads, defaults to 5                                   |
| REDIS_URL             | Used in `config/cable.yml`                                              |
| WEB_CONCURRENCY       | Number of Puma workers. We default to threads only, no workers          |

## Contents

All of the following have been installed and pre-configured:

### Base system

* Rails 5.2.0
* Ruby 2.5.1
* [pg](https://github.com/ged/ruby-pg) for `ActiveRecord`

### General

* [devise](https://github.com/plataformatec/devise)
* [figaro](https://github.com/laserlemon/figaro)
* [foreman](https://github.com/ddollar/foreman)
* [fast_jsonapi](https://github.com/Netflix/fast_jsonapi)
* [pundit](https://github.com/elabs/pundit)
* [sidekiq](https://github.com/mperham/sidekiq)

### Frontend

All of these are managed by `yarn`.

* [bootstrap4](https://www.npmjs.com/package/bootstrap-v4-dev)
* [jquery](https://www.npmjs.com/package/jquery)
* [jquery-ujs](https://www.npmjs.com/package/jquery-ujs/)
* [popper.js](https://www.npmjs.com/package/popper.js)

### Development

* [Brakeman](https://github.com/presidentbeef/brakeman)
* [bullet](https://github.com/flyerhzm/bullet)
* [letter_opener](https://github.com/ryanb/letter_opener)
* [memory_profiler](https://github.com/SamSaffron/memory_profiler)
* [newrelic_rpm](https://github.com/newrelic/rpm)
* [nullalign](https://github.com/tcopeland/nullalign)
* [pry](https://github.com/rweng/pry-rails)
* [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug)
* [pry-doc](https://github.com/pry/pry-doc)
* [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler)
* [RuboCop](https://github.com/bbatsov/rubocop)

### Test

Rspec has been preconfigured for Rails 5.1+ system tests.

* No need to `require 'rails_helper`, we do it in `.rspec`
* [bundler-audit](https://github.com/rubysec/bundler-audit) (runs on CircleCI)
* [capybara](https://github.com/teamcapybara/capybara)
* [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
* [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
* [spring-commands-rspec](https://github.com/jonleighton/spring-commands-rspec)
* [webmock](https://github.com/bblimke/webmock)

### Production

* [airbrake](https://github.com/airbrake/airbrake)
* [heroku-deflater](https://github.com/romanbsd/heroku-deflater)
* [lograge](https://github.com/roidrage/lograge)
* [rails_12factor](https://github.com/heroku/rails_12factor)
* [rake-timeout](https://github.com/heroku/rack-timeout)
* [secureheaders](https://github.com/twitter/secureheaders)

## Removed

The following default Rails gems have been removed:

* [coffee-rails](https://github.com/rails/coffee-rails)
* [jbuilder](https://github.com/rails/jbuilder)

## Notes

### Webpacker, the asset pipeline, and ES6

By default ES6 will not work for files in `app/assets/javascript` since Uglifier will fail to
process them. This is why we applied the following change to `config/production.rb`, which allows
you to use ES6 project wide:

```diff
-  config.assets.js_compressor = :uglifier
+  config.assets.js_compressor = Uglifier.new(harmony: true)
```

Also note that for everything to work properly on Heroku, you need to set up your buildpacks like
this:

```
heroku buildpacks:clear
heroku buildpacks:set heroku/nodejs
heroku buildpacks:add heroku/ruby
```

### Custom classes

* `ApplicationDecorator`: lightweight alternative to Draper or similar gems.
* `ApplicationForm`: Minimal form class based on `ActiveModel`.
* `ApplicationPresenter`: a subclass of `ApplicationDecorator` for presenters, includes tag helpers.

All custom classes are fully documented with [yard](https://yardoc.org) and come with generators.

Use `yard doc` to generate documentation and `yard server --reload` or `yard server --gems` to start
a local documentation server.

### Gemfile.dev / Gemfile.dev.lock

If you want to add specific gems for development that may not be interesting for other developers,
you can add a `Gemfile.dev` (ignored by our `.gitignore`). Gems listed there can be installed with
`bundle install --gemfile Gemfile.dev` and the resulting lock file is gitignored too.

Example `Gemfile.dev`:

```ruby
source 'https://rubygems.org'

eval_gemfile 'Gemfile'

gem 'awesome_print'
```

The `eval_gemfile` line will ensure that all gems from your regular `Gemfile` will be included too.
The `BUNDLE_GEMFILE` variable can be used to let Bundler now which gemfile to use:

```
BUNDLE_GEMFILE=Gemfile.dev rails c
```

### `Rack::RejectTrace` middleware

There's a custom middleware (`Rack::RejectTrace`) for completely disabling the HTTP TRACE method as
required by certain security audits. It can be enabled via the `BLOCK_HTTP_TRACE` environment
variable.

### Favicons

Favicons were generated with [Real Favicon Generator](https://realfavicongenerator.net/), consider
using the same tool when replacing them for your project.
