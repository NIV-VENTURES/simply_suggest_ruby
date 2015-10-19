module SimplySuggest
  class ApiRequest
    def get url, params = {}, headers = {}
      begin
        response = rest_client.get do |request|
          configure_request(url, request: request, params: params, headers: headers)
        end
        parse_response(response.body)
      rescue => e
        handle_error(e)
      end
    end

  protected
    def configure_request(url, request: nil, params: nil, headers: nil, body: nil)
      if request
        request.url "/#{url}.json"
        request.params.merge!(params) if params
        request.headers['Content-Type'] = 'application/json'
        request.headers.merge!(headers) if headers
        request.body = body if body
        request.options.timeout = SimplySuggest.config.timeout
      end
    end

    def rest_client
      con = Faraday.new(url: SimplySuggest.config.api_domain) do |faraday|
        faraday.response :raise_error
        faraday.adapter Faraday.default_adapter
      end
      con.params[:secretKey] = SimplySuggest.config.secret_key

      con
    end

    def parse_response(response_body)
      parsed_response = nil

      if response_body && !response_body.empty?
        begin
          parsed_response = MultiJson.load(response_body)
        rescue MultiJson::ParseError
          error = Error.new("Unparseable response: #{response_body}")
          error.title = "UNPARSEABLE_RESPONSE"
          error.status_code = 500
          raise error
        end
      end

      parsed_response.delete("pages") if parsed_response["pages"].present?

      parsed_response
    end

    def handle_error(error)
      error_to_raise = nil

      begin
        error_to_raise = Error.new(error.message)

        if error.is_a?(Faraday::ClientError) && error.response
          parsed_response = MultiJson.load(error.response[:body]) rescue nil

          if parsed_response
            error_to_raise.body = parsed_response
            error_to_raise.title = parsed_response["title"] if parsed_response["title"]
            error_to_raise.detail = parsed_response["detail"] if parsed_response["detail"]
          end

          error_to_raise.status_code = error.response[:status]
          error_to_raise.raw_body = error.response[:body]
        end
      rescue MultiJson::ParseError
        error_to_raise.message = error.message
        error_to_raise.status_code = error.response[:status]
      end

      raise error_to_raise
    end
  end
end