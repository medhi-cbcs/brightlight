source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use PostgresSQL
gem 'pg', '~> 0.18.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Autocomplete in forms, using jQuery to get list of matched records
gem 'rails-jquery-autocomplete'

# To show progress on link clicks
gem 'nprogress-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# https://github.com/tzinfo/tzinfo/wiki/Resolving-TZInfo::DataSourceNotFound-Errors
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# We use slim here instead or the default erb
gem 'slim-rails'

# Pjax
gem 'pjax_rails'

# Pagination
gem 'will_paginate', '~> 3.0.6'

# Search in table
gem 'filterrific'

# The Materialize UI framework
gem 'materialize-sass'

# jQuery UI
gem 'jquery-ui-rails'

# Wrapper for Google Books API
gem 'google_books', git: 'https://medhiwidjaja@github.com/medhiwidjaja/google_books.git'

gem 'hashie'

# To convert number to words
gem 'numbers_and_words'

# Login with Devise & OmniAuth Google+ OAuth2
gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'

# Nested form handling
gem 'cocoon'

# Scenic provides support for using database views in Rails
gem 'scenic'

# For converting HTML to PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', '~> 0.9.9.3'

# Slug for friendly URLs. Using specific fork for Rails 4.0 compatibility
gem 'slug', git:'https://github.com/subimage/slug.git'

# For creating and importing database
gem 'activerecord-import'
gem 'seed-fu', '~> 2.3'

# Barcode generator
gem 'barby'
gem 'chunky_png'

# Authorization
gem 'cancancan', '~> 1.10'

# WYSIWYG editing using TinyMCE
gem 'tinymce-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# For importing data from Excel
gem 'roo', '~> 2.3.2'

# For connecting to SQL server
gem 'tiny_tds'
  
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'forgery'
  gem 'populator'
  gem 'letter_opener'
  gem 'rspec-rails', '~> 3.5'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # irb messed up on Windows, use pry to replace irb as console
  gem 'pry-rails'

end
