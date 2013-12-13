=== Configuration

You may use a file, for example /config/initializers/simple_signature.rb with contents:

  SimpleSignature.configure do |c|
     c.init_keystore(keys)
     c.expiry_time = 900
     c.key_param_name = 'sigkey'
     c.signature_param_name = 'signature'
     c.timestamp_param_name = 'timestamp'
  end
