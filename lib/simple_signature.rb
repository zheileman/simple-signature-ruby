module SimpleSignature
  autoload :Keystore, 'simple_signature/keystore'
  autoload :Generator, 'simple_signature/generator'
  autoload :Validator, 'simple_signature/validator'
  autoload :ValidatorError, 'simple_signature/validator_error'
  autoload :RequestValidator, 'simple_signature/request_validator'


  class << self
    attr_writer :keystore, :expiry_time, :key_param_name, :signature_param_name, :timestamp_param_name

    def configure
      if block_given?
        yield self
        true
      end
    end

    def init_keystore keys
      @keystore = Keystore.new(keys)
    end

    def keystore
      @keystore || init_keystore({})
    end
    def expiry_time
      @expiry_time ||= 900
    end
    def key_param_name
      @key_param_name ||= 'sigkey'
    end
    def signature_param_name
      @signature_param_name ||= 'signature'
    end
    def timestamp_param_name
      @timestamp_param_name ||= 'timestamp'
    end
  end
end
