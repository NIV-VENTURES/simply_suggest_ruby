module SimplySuggest
  class Error < StandardError
    attr_accessor :error_code, :message, :body, :raw_body, :status_code
  end
end