require 'bundler/setup'
Bundler.setup

require 'simply_suggest'

RSpec.configure do |config|
  config.color = true
  config.include SimplySuggest::ViewHelper
  config.include ActionView::Helpers::TagHelper
end