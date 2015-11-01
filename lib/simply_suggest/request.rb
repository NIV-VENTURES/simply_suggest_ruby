module SimplySuggest
  class Request
    class << self
      def method_missing(sym, *args, &block)
        new.send(sym, *args, &block)
      end
    end

    def initialize
      @path_parts = []
      @params     = {}
    end

    def method_missing(method, *args)
      @path_parts << method.to_s.downcase
      @path_parts << args if args.length > 0
      @path_parts.flatten!
      self
    end

    def get *args
      @path_parts += args.to_a
      values = api_request.get(path, @params)
      reset
      values
    end

    def post *args
      @path_parts += args.to_a
      values = api_request.post(path, @params)
      reset
      values
    end

    def patch *args
      @path_parts += args.to_a
      values = api_request.patch(path, @params)
      reset
      values
    end

    def limit num
      add_param :limit, num
      self
    end

    def page num
      add_param :page, num
      self
    end

    def add_param name, value
      @params[name.to_sym] = value
      self
    end

    def add_params params = {}
      params.each_pair do |name, value|
        @params[name.to_sym] = value
      end
      self
    end

    def path
      @path_parts.join('/')
    end

    def reset
      @path_parts = []
    end

  protected
    def api_request
      @api_request ||= SimplySuggest::ApiRequest.new
    end
  end
end