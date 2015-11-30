module SimplySuggest
  class Configuration
    # SimplySuggest publicKey
    #
    # default: nil
    attr_accessor :public_key

    # SimplySuggest secretKey
    #
    # default: nil
    attr_accessor :secret_key

    # Read Timeout
    #
    # default: 2
    attr_accessor :timeout

    # Api Version
    #
    # default: v1
    attr_accessor :api_version

    # Api Domain
    #
    # default: simply-suggest.com
    attr_accessor :api_domain

    # Api Domain
    #
    # default: simply-suggest.com
    attr_accessor :domain

    # Autoload objects
    #
    # default: false
    attr_accessor :autoload

    # Perform Caching, RAILS ONLY
    #
    # default: false
    attr_accessor :caching

    def initialize
      @secret_key  = nil
      @public_key  = nil
      @timeout     = 2
      @api_version = "v1"
      @domain      = "simply-suggest.com"
      @api_domain  = "http://v1.simply-suggest.com"
      @autoload    = false
      @caching     = false
    end
  end

  class << self
    def configure
      @config ||= Configuration.new
      yield @config
    end

    def config
      @config ||= Configuration.new
    end
  end
end