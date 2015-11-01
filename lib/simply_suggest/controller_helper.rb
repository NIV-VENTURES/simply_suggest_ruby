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
      load      = options.delete(:load)
      load      = SimplySuggest.config.autoload if load.nil?

      klass     = item.is_a?(Hash) ? item.delete(:class) : item.class.to_s.downcase
      object_id = item.is_a?(Hash) ? item.delete(:object_id) : item.id

      data = request_object.object_types.send(klass).object.recommendations.page(page).limit(limit).get(object_id)
      return [] if data["recommendations"].blank?
      ids = data["recommendations"].map { |d| d["recommendation_id"] }
      return item.class.where(id: ids) if load
      ids
    end

    # returns recommendations for the user_id
    #
    # user_id : integer
    # options : hash [optional]
    #
    def user_recommendations user_id, options = {}
      object_type = options.delete(:object_type) || options.delete(:class)
      limit       = options.delete(:limit) || 10
      page        = options.delete(:page)  || 1
      load        = options.delete(:load)
      load        = SimplySuggest.config.autoload if load.nil?

      if object_type.present?
        data = request_object.user.send(object_type).recommendations.page(page).limit(limit).get(user_id)
      else
        data = request_object.user.recommendations.page(page).limit(limit).get(user_id)
      end
      return [] if data["recommendations"].blank?
      return data["recommendations"].map { |d| d["object_type"].classify.constantize.where(id: d["recommendation_id"]).first }.reject(&:nil?) if load
      data["recommendations"].map { |d| { type: d["object_type"], id: d["recommendation_id"] } }
    end

    # returns trending data for the object type
    #
    # klass : string
    # options : hash [optional]
    #
    def get_trending_objects klass, options = {}
      limit = options.delete(:limit) || 10
      page  = options.delete(:page) || 1
      load  = options.delete(:load)
      load  = SimplySuggest.config.autoload if load.nil?

      data = request_object.object_type.trending.send(klass).page(page).limit(limit).get
      return [] if data["trending"].blank?
      return data["trending"].map { |d| d["object_type"].classify.constantize.where(id: d["external_id"]).first }.reject(&:nil?) if load
      data["trending"].map { |d| { type: d["object_type"], id: d["external_id"] } }
    end

  protected
    def request_object
      @request_object ||= SimplySuggest::Request.new
    end
  end
end