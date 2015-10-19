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

    def limit num
      @params[:limit] = num
      self
    end

    def page num
      @params[:page] = num
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