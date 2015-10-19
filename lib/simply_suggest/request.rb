module SimplySuggest
  class Request
    attr_reader :options

    def initialize data = {}
      @options = data
    end

    def recommendations_for item, options = {}
      limit = options.delete(:limit) || 4

      get("predict", item.class.to_s.downcase, item.id, limit)
    end

    def user_recommendations user_id, options = {}
      limit = options.delete(:limit) || 4
      klass = options.delete(:class)

      get("user", klass, user_id, limit)
    end

  protected
    def get method, class_name, id, limit
      case SimplySuggest.config.api_type
      when :json
        begin
          return get_json(method, class_name, id, limit)
        rescue => e
          handle_error(e)
        end
      else
        raise "Unknown Api Type" if Rails.env.development?
      end

      []
    end

    def get_json method, class_name, id, limit
      url = "http://v1.#{SimplySuggest.config.domain}/"
      url += [method, class_name, id.to_s].reject(&:blank?).join("/")
      url += ".json?key=#{SimplySuggest.config.api_key}&limit=#{limit}"

      Logger.new("log/simply_suggest.log").info(url) rescue nil if Rails.env.development?

      timeout(SimplySuggest.config.timeout) {
        json_string = open(url).read
        return JSON.parse(json_string) rescue []
      }

      []
    end

    def handle_error error
      case error.class.to_s
      when "OpenURI::HTTPError"
        # TODO check response status
        raise "Wrong Api-Key provided" if Rails.env.development?
      when "Timeout::Error"

      end
    end
  end
end