# Varslist
Varslist is a ruby gem that helps to identify the env variables that are being used in your project.

In your rails project by default the the environment variables that are missing are shown when starting the server

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'varslist'
```

And then execute:

```bash
  bundle install
```

Or install it yourself as:

```bash
  gem install varslist
```

## Usage

To generate the configuration initializer file, run:

```bash
  rails generate varslist:install
```

This will create a `config/initializers/varslist.rb` file where you can customize the gem settings.

