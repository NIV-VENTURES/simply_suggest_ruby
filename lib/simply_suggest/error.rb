module SimplySuggest
  class Error < StandardError
    attr_accessor :error_code, :message, :body, :raw_body, :status_code

    def to_s
      [@error_code, @message, @body, @raw_body, @status_code].join("\n")
    end
  end
end