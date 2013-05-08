# Styles extension for Refinery CMS.

A product recommend extension for Refinery CMS.

Recommender provides other extensions with:

* restful api for crud
* frontend build with backbone


Installation
------------------------------------------------------------------------------

First, add Recommender to your Gemfile... it hasn't been released to Rubygems yet so we'll grab it from git.

Recommender use backbone for frontend pages, and jbuilder to generate backend json api.
So you also need to add those gems.

```ruby
gem 'refinerycms-styles', :github => 'bbtfr/refinerycms-styles'

gem 'backbone-on-rails'
```

Run the generators to create the migration files.

```bash
rails g refinery:styles
rake db:migrate
```


License
------------------------------------------------------------------------------

This project rocks and uses MIT-LICENSE.
