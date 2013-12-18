require 'simple_signature'

module SimpleSignature

  class Generator
    require 'simple_signature/query'
    require 'openssl'
    
    attr_reader :token, :data

    def initialize key, timestamp = nil, &block
      @data = []
      @token = SimpleSignature.keystore.get(key)
      @timestamp = timestamp

      yield self if block_given?
    end

    def reset!
      @data.clear
      @timestamp = nil
      @signature = nil
    end

    def include *args
      @data << args
    end
    
    def include_query query
      @data << Query.new(query).sort.to_s
    end
    
    def timestamp
      @timestamp ||= Time.now.to_i
    end

    def signature
      if @token
        @signature ||= sign(@token.secret, payload)
      end
    end

    def auth_hash
      {
        SimpleSignature.key_param_name => @token.key, 
        SimpleSignature.signature_param_name => signature, 
        SimpleSignature.timestamp_param_name => timestamp
      }
    end

    def auth_params
      URI.encode_www_form(auth_hash)
    end
    
    
    private
    
    def sign secret, payload
      hmac.hexdigest(sha1, secret, payload)
    end

    def hmac
      OpenSSL::HMAC
    end 
  
    def sha1
      @sha1 ||= OpenSSL::Digest::SHA1.new
    end
    
    def payload
      [@data.join, timestamp].join
    end
  end
end
