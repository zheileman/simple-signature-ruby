require 'simple_signature'

module SimpleSignature

  class RequestValidator < SimpleSignature::Validator
    attr_reader :request

    def initialize request
      @request = request

      super(key, signature, timestamp) do |v|
        v.include method, path, query_string, body
      end
    end

    def key
      @request.params[SimpleSignature.key_param_name]
    end
    def signature
      @request.params[SimpleSignature.signature_param_name]
    end
    def timestamp
      @request.params[SimpleSignature.timestamp_param_name]
    end
    def method
      @request.request_method.upcase
    end
    def path
      @request.path
    end
    def body
      [@request.body.read, @request.body.rewind][0]
    end
    def query_string
      @request.query_string.sub(
        URI.encode_www_form(@request.params.select { 
          |k,_| [SimpleSignature.key_param_name, SimpleSignature.signature_param_name, SimpleSignature.timestamp_param_name].include?(k) 
        }), ''
      )
    end
  end

end
