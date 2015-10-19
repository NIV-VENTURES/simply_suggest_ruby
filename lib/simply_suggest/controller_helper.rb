module SimplySuggest
  module ControllerHelper
    extend ActiveSupport::Concern

    # returns recommendations for the item
    #
    # item : object
    # options : hash [optional]
    #
    def recommendations_for item, options = {}
      request_object.recommendations_for item, options
    end

    # returns recommendations for the user_id
    #
    # user_id : integer
    # options : hash [optional]
    #
    def user_recommendations user_id, options = {}
      request_object.user_recommendations user_id, options
    end

  protected
    def request_object
      @request_object ||= SimplySuggest::Request.new
    end
  end
end