module SimplySuggest
  class Error < StandardError
    attr_accessor :title, :detail, :body, :raw_body, :status_code
  end
end