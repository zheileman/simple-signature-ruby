require 'spec_helper'
require 'simple_signature/generator'

describe SimpleSignature::Generator do
  
  subject do
    SimpleSignature::Generator
  end

  let(:keystore) { SimpleSignature::Keystore.new({'service' => {'secret' => 'xxxxx'}}) }

  before :each do
    SimpleSignature.stub(keystore: keystore)
  end

  describe '.new' do
    it "should not fail for a non existing key" do
      expect(subject.new('test')).not_to be_nil
    end

    it "should accept a timestamp argument" do
      timestamp = Time.now.to_i - 10000
      expect(subject.new('service', timestamp).timestamp).to eq(timestamp)
    end

    it "should generate a timestamp if there is no argument" do
      timestamp = Time.now.to_i
      expect(subject.new('service').timestamp).to eq(timestamp)
    end
    
    it "should accept a block with calls to #include" do
      pending 'blah'
      expect(subject.new('service') do |g|
        g.include 'some text here'
        g.include 'some more text'
      end).to receive(:include).twice
    end
  end

  describe "#signature" do
    it "should return a signature" do
      expect(subject.new('service').signature).not_to be_nil
    end
    
    it "should return nil for an unknown key" do
      expect(subject.new('test').signature).to be_nil
    end
  end

  describe "#auth_hash" do
    it "should return a hash with the signature information" do
      key = 'service'
      hash = subject.new(key).auth_hash
      expect(hash['sigkey']).to eq(key)
      expect(hash['timestamp']).not_to be_nil
      expect(hash['signature']).not_to be_nil
    end
  end
end
