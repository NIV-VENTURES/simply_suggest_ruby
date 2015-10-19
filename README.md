# BotDetection

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Installation

Add this line to your application's Gemfile:

  gem 'simply_suggest'

And then execute:

  $ bundle

Or install it yourself as:

  $ gem install simply_suggest

## Changes

See the [CHANGELOG.md](CHANGELOG.md) file for details.

## Usage

After installing the GEM you can use within your controllers or helpers the following methods

	# this will return an array of object ids which are related to this object
	recommendations_for object

	# this will return an hash of data which are recommended for the user
	user_recommendations user_id

### JavaScript-Implementation

	# to use the javascript tracking methods you need to add this line to your <head> or footer
	<%= simply_suggest_script %>

	# then within the footer you can call this function to get the javascript calls
	<%= get_tracking_code user_id: unique_user_id, object_id: unique_object_id, object_type: object_type, event: "" %>

## Contributing

1. Fork it ( https://github.com/SimplySuggest/simply_suggest_ruby.git/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request