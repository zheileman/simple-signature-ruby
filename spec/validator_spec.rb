require 'spec_helper'
require 'simple_signature/validator'

describe SimpleSignature::Validator do
  
  subject do
    SimpleSignature::Validator
  end

  let(:keystore) { SimpleSignature::Keystore.new({'service' => {'secret' => 'xxxxx'}}) }

  before :each do
    SimpleSignature.stub(keystore: keystore)
  end
  
  describe '.new' do
    it "should accept a key, a signature and a timestamp as arguments" do
      expect(subject.new('service', 'signature', Time.now.to_i)).not_to be_nil
    end

    it "should not fail for a non existing key" do
      expect(subject.new('test', 'signature', Time.now.to_i)).not_to be_nil
    end
  end

  describe 'validate signatures' do
    let(:generator) {
      SimpleSignature::Generator.new('service') do |g|
        g.include 'some text here'
        g.include 'some more text'
      end
    }

    it "should validate a proper signature" do
      key = generator.token.key
      timestamp = generator.timestamp
      signature = generator.signature

      validator = SimpleSignature::Validator.new(key, signature, timestamp) do |v|
        v.include 'some text here'
        v.include 'some more text'
      end

      expect(validator.success?).to be_true
      expect(validator.error).to be_nil
    end

    it "should fail to validate a signature with expired timestamp" do
      key = generator.token.key
      timestamp = generator.timestamp - 86400  # 1 day in seconds
      signature = generator.signature

      validator = SimpleSignature::Validator.new(key, signature, timestamp) do |v|
        v.include 'some text here'
        v.include 'some more text'
      end

      expect(validator.expired?).to be_true
      expect(validator.success?).to be_false
      expect(validator.error.code).to eq('signature_expired')
    end

    it "should fail to validate a signature without timestamp" do
      key = generator.token.key
      timestamp = nil
      signature = generator.signature

      validator = SimpleSignature::Validator.new(key, signature, timestamp) do |v|
        v.include 'some text here'
        v.include 'some more text'
      end

      expect(validator.expired?).to be_true
      expect(validator.success?).to be_false
      expect(validator.error.code).to eq('signature_expired')
    end

    it "should fail to validate an incorrect signature" do
      key = generator.token.key
      timestamp = generator.timestamp
      signature = generator.signature + 'xxx'

      validator = SimpleSignature::Validator.new(key, signature, timestamp) do |v|
        v.include 'some text here'
        v.include 'some more text'
      end

      expect(validator.expired?).to be_false
      expect(validator.success?).to be_false
      expect(validator.error.code).to eq('signature_invalid')
    end
  end
  
end
