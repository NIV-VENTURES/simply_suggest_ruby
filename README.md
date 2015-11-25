# SimplySuggest

[![Gem Version](https://badge.fury.io/rb/simply_suggest.svg)](https://badge.fury.io/rb/simply_suggest)
[![Build Status](https://semaphoreci.com/api/v1/projects/8604eb77-808e-479b-8502-de90d365a29c/606781/shields_badge.svg)](https://semaphoreci.com/niv-ventures/simply_suggest_ruby)
[![Build Status](https://travis-ci.org/NIV-VENTURES/simply_suggest_ruby.svg?branch=master)](https://travis-ci.org/NIV-VENTURES/simply_suggest_ruby)
[![security](https://hakiri.io/github/NIV-VENTURES/simply_suggest_ruby/master.svg)](https://hakiri.io/github/NIV-VENTURES/simply_suggest_ruby/master)
[![Code Climate](https://codeclimate.com/github/NIV-VENTURES/simply_suggest_ruby/badges/gpa.svg)](https://codeclimate.com/github/NIV-VENTURES/simply_suggest_ruby)

SimplySuggest implementation for Ruby.
You need an account at www.simply-suggest.com to use this gem.

Direct API-access to all the methods which are available and several helpers to get things a bit less complex.

## Installation

Add this line to your application's Gemfile:

	gem 'simply_suggest'

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install simply_suggest

## Configuration

For rails put initialization into config/initializers/simply_suggest.rb

	SimplySuggest.configure do |c|
      c.secret_key = "YOUR SECRET KEY"
      c.public_key = "YOUR PUBLIC KEY"
    end

## Usage

After installing the GEM you can use within your controllers or helpers the following methods

This will return an array of object ids which are related to this object
	recommendations_for @product
	# => [1,2,3,4,5]

This will autoload all objects from your database

	recommendations_for @product, load: true
	# => [Product, Product, Product]

This will return an hash of data which are recommended for the user

	user_recommendations current_user.id
	# => [{ type: "article", id: 1 }, { type: "product", id: 1 }]

This will autoload the data from your database

	user_recommendations current_user.id, load: true
	# => [Product, Article, Product]

This will load the current trending objects

	get_trending_objects "article", load: true
	# => [Article, Article, Article]

You can use the search api accessing the following method in your controller

	search_objects "lorem ipsum", "article", load: true
	# => { results: [Article, Article, Article], facets: nil, conditions: nil }

You can specify facet fields

	search_objects "lorem ipsum", "article", load: true, facets: [:category_id]
	# => { results: [Article, Article, Article], facets: { category_id: { key: 4, doc_count: 2 } }, conditions: nil }

you can set autoload within the config to let load default to true

	SimplySuggest.configure do |c|
      c.autoload = false
    end

All helpers will raise a ``SimplySuggest::Error`` if something went wrong so you easily catch them.

### JavaScript-Implementation

to use the javascript tracking methods you need to add this line to your <head> or footer

	<%= simply_suggest_script %>

then somewhere on your side you can call this function to get the javascript calls

	<%= get_tracking_code user_id: unique_user_id, object_id: unique_object_id, object_type: object_type, event: "view" %>

available event types are

```ruby
:buy
:like
:dislike
:favorite
:view
:basket or "add-to-basket"
:comment
:subscribe
```

You should use the primary key of your user or generate and send a unique user id which is saved to the session or cookie so you send always the same one

## Changes

See the [CHANGELOG.md](CHANGELOG.md) file for details.

## Contributing to SimplySuggest

1. Check out the Master
2. Fork the project.
3. Start a feature/bugfix branch.
4. Commit and push until you are happy with your contribution.