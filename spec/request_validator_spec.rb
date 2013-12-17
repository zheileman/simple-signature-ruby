require 'spec_helper'
require 'simple_signature/request_validator'

describe SimpleSignature::RequestValidator do
  
  subject do
    SimpleSignature::RequestValidator
  end

  let(:keystore) { SimpleSignature::Keystore.new({'service' => {'secret' => 'xxxxx'}}) }


  before :each do
    SimpleSignature.stub(keystore: keystore)
  end
  
  describe 'validate signatures' do
    let(:generator) {
      SimpleSignature::Generator.new('service') do |g|
        g.include request.request_method, request.path, request.query_string, request.body.read
      end
    }

    let(:request) {
      double('request', 
        request_method: 'POST', 
        path: '/api/v1.3/accounts.json', 
        query_string: 'p1=v1&p2=v2', 
        body: double(read: 'test=xxx', rewind: true))
    }
    
    it "should validate a proper signature from a request with query params" do
      key = generator.token.key
      timestamp = generator.timestamp
      signature = generator.signature

      allow(request).to receive(:params).and_return(generator.auth_hash)
      allow(request).to receive(:query_string).and_return(['p1=v1', generator.auth_params, 'p2=v2'].join('&'))

      validator = subject.new(request)

      expect(validator.success?).to be_true
      expect(validator.error).to be_nil
    end
  end
  
end
