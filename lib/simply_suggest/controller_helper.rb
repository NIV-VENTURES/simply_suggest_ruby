module SimplySuggest
  module ControllerHelper
    extend ActiveSupport::Concern

    # returns recommendations for the item
    #
    # item : object
    # options : hash [optional]
    #
    def recommendations_for item, options = {}
      limit     = options.delete(:limit) || 10
      page      = options.delete(:page)  || 1
      klass     = item.is_a?(Hash) ? item.delete(:class) : item.class.to_s.downcase
      object_id = item.is_a?(Hash) ? item.delete(:object_id) : item.id

      data = request_object.object_types.send(klass).object.recommendations.page(page).limit(limit).get(object_id)
      return [] if data["record_predictions"].blank?
      data["record_predictions"].map { |d| d["recommendation_id"] }
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