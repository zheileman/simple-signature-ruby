module SimpleSignature
  
  class ValidatorError < Struct.new(:code, :message)
    def self.expired
      new('signature_expired', 'Signature has expired.')
    end
    def self.invalid
      new('signature_invalid', 'Signature is not valid.')
    end
  end
  
end
