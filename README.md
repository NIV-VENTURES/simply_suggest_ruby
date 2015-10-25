# SimplySuggest

SimplySuggest implementation for Ruby.

Direct API-access to all the methods which are available.

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

	# this will return an array of object ids which are related to this object
	recommendations_for @product
	# => [1,2,3,4,5]
	
	recommendations_for @product, load: true
	# => [Product, Product, Product]

	# this will return an hash of data which are recommended for the user
	user_recommendations current_user.id
	# => [{ type: "article", id: 1 }, { type: "product", id: 1 }]
	
	user_recommendations current_user.id, load: true
	# => [Product, Article, Product]

you can set autoload within the config to let load default to true

	SimplySuggest.configure do |c|
      c.autoload = false
    end

All helpers will raise a ``SimplySuggest::Error`` if something went wrong so you easily catch them.

### JavaScript-Implementation

	# to use the javascript tracking methods you need to add this line to your <head> or footer
	<%= simply_suggest_script %>

	# then somewhere on your side you can call this function to get the javascript calls
	<%= get_tracking_code user_id: unique_user_id, object_id: unique_object_id, object_type: object_type, event: "view" %>
	# available event types are: buy, like, dislike, favorite, view and add-to-basket
	# you should generate and send a unique user id which is saved to the session or cookie so you send always the same one

## Changes

See the [CHANGELOG.md](CHANGELOG.md) file for details.

## Contributing to SimplySuggest

1. Check out the Master
2. Fork the project.
3. Start a feature/bugfix branch.
4. Commit and push until you are happy with your contribution.