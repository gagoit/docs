# frozen_string_literal: true

module SimpleApi
  class Client
    attr_accessor :host, :username, :password

    ACTIONS_HASH = {
      create: :post,
      update: :put,
      upsert: :patch,
      delete: :delete,
      fetch: :get
    }.freeze

    def initialize host: nil, username: nil, password: nil
      @path_parts = []
      @host = host
      @username = username
      @password = password
    end

    ACTIONS_HASH.each do |action, http_method|
      define_method(action) do |argument = {}|
        ::HTTParty.public_send http_method, full_path, **argument
      ensure
        reset
      end
    end

    def method_missing method, *args
      @path_parts << method.to_s.downcase
      @path_parts << args if args.length.positive?
      @path_parts.flatten!
      self
    end

    def respond_to_missing? _method_name, _include_private = false
      true
    end

    def send *args
      if args.empty?
        method_missing(:send, args)
      else
        __send__(*args)
      end
    end

    def path
      @path_parts.join("/")
    end

    def full_path
      @host + path
    end

    protected

    def reset
      @path_parts = []
    end
  end
end

client = SimpleApi::Client.new host: "https://5f60d84490cf8d00165586ea.mockapi.io/"

# /coupon_types
client.coupon_types.fetch

# /coupon_types/1/coupons
client.coupon_types(1).coupons.fetch

# /coupon_types/1/coupons/1
client.coupon_types(1).coupons(1).fetch
