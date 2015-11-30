module SimplySuggest
  module ControllerHelper
    extend ActiveSupport::Concern

    # returns recommendations for the item
    #
    # item : object
    # options : hash [optional]
    #
    def recommendations_for item, options = {}
      options = options.reverse_merge(default_options)

      klass     = item.is_a?(Hash) ? item.delete(:class) : item.class.to_s.downcase
      object_id = item.is_a?(Hash) ? item.delete(:object_id) : item.id

      data = request_object.object_types.send(klass).object.recommendations.page(options[:page]).limit(options[:limit]).get(object_id)
      return [] if data["recommendations"].blank?
      ids = data["recommendations"].map { |d| d["recommendation_id"] }
      return klass.classify.constantize.where(id: ids) if options[:load]
      ids
    end

    # returns recommendations for the user_id
    #
    # user_id : integer
    # options : hash [optional]
    #
    def user_recommendations user_id, options = {}
      options = options.reverse_merge(default_options)
      klass   = options.delete(:object_type) || options.delete(:class)

      if klass.present?
        data = request_object.user.send(klass).recommendations.page(options[:page]).limit(options[:limit]).get(user_id)
      else
        data = request_object.user.recommendations.page(options[:page]).limit(options[:limit]).get(user_id)
      end
      return [] if data["recommendations"].blank?

      if options[:load]
        return klass.classify.constantize.where(id: data["recommendations"].map { |d| d["recommendation_id"] }) if klass.present?
        return data["recommendations"].map { |d| d["object_type"].classify.constantize.where(id: d["recommendation_id"]).first }.reject(&:nil?)
      end
      data["recommendations"].map { |d| { type: d["object_type"], id: d["recommendation_id"] } }
    end

    # returns trending data for the object type
    #
    # klass : string
    # options : hash [optional]
    #
    def get_trending_objects klass, options = {}
      options = options.reverse_merge(default_options)

      data = request_object.object_type.trending.send(klass).page(page).limit(limit).get
      return [] if data["trending"].blank?
      return klass.classify.constantize.where(id: data["trending"].map { |d| d["external_id"] }) if options[:load]
      data["trending"].map { |d| { type: d["object_type"], id: d["external_id"] } }
    end

    def search_objects query, klass, options = {}
      options = options.reverse_merge(default_options)

      request = request_object.object_type.search.send(klass).page(options[:page]).limit(options[:limit]).add_params(query: query)
      request.add_param(:conditions, options[:conditions]) if options[:conditions].present?
      request.add_param(:facets, options[:facets]) if options[:facets].present?

      data = request.get
      return [] if data["objects"].blank?
      if options[:load]
        values = {}
        values[:results]    = data["objects"].map { |d| d["object_type"].classify.constantize.where(id: d["external_id"]).first }.reject(&:nil?)
        values[:facets]     = data["facets"]
        values[:conditions] = data["conditions"]

        return values
      end

      data
    end

  protected
    def request_object
      @request_object ||= SimplySuggest::Request.new
    end

    def default_options
      {
        limit: 10,
        page: 1,
        load: SimplySuggest.config.autoload
      }
    end
  end
end