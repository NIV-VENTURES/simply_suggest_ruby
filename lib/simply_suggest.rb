require 'action_controller'
require 'action_view'
require "faraday"
require "multi_json"

module SimplySuggest
end

require 'simply_suggest/version'
require 'simply_suggest/configuration'
require 'simply_suggest/request'
require 'simply_suggest/error'
require 'simply_suggest/api_request'
require 'simply_suggest/controller_helper'
require 'simply_suggest/view_helper'

ActionController::Base.send :include, SimplySuggest::ControllerHelper
ActionView::Base.send :include, SimplySuggest::ViewHelper