require 'simple_signature'

module SimpleSignature

  class Validator
    require 'simple_signature/validator_error'

    attr_reader :timestamp, :error

    def initialize key, signature, timestamp, &block
      @signature = signature
      @timestamp = timestamp
      @generator = Generator.new(key, timestamp, &block)
    end

    def expired?
      Time.now > Time.at(@timestamp.to_i + SimpleSignature.expiry_time) rescue true
    end

    def success?
      if expired?
        @error = ValidatorError.expired
      elsif @generator.signature != @signature
        @error = ValidatorError.invalid
      end
      @error.nil?
    end
  end

end
