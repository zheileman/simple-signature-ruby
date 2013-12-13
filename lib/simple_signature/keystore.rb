module SimpleSignature

  class Keystore < Struct.new(:secrets)
    
    def get key
      secrets.has_key?(key) ? OpenStruct.new({ key: key }.merge!(secrets[key])) : nil
    end

    def empty?
      secrets.empty?
    end
  end

end
