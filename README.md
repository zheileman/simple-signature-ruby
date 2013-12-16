# Configuration

You may use a file, for example `/config/initializers/simple_signature.rb` with contents:

```ruby
  SimpleSignature.configure do |c|
    c.init_keystore(keys)  
    c.expiry_time = 900  
    c.key_param_name = 'sigkey'  
    c.signature_param_name = 'signature'  
    c.timestamp_param_name = 'timestamp'  
  end  
```

Everything is optional, but you would probably like to initialize the keystore at least.  
In `c.init_keystore(keys)` keys is a hash with n-keys and values in the format:

```ruby
  {
    'key1': { secret: 'xxxx' },
    'key2': { secret: 'yyy' }
  }
```

Full example of an initializer reading a YML file with pre-shared keys:

```ruby
file_path = File.join("#{Rails.root}", "config", "keystore.yml")

unless File.exists?(file_path)
  puts "[Keystore] Shared keys file not found. Copy keystore-sample.yml to keystore.yml"
end

keys = YAML.load_file(file_path) rescue {}

SimpleSignature.configure do |c|
   c.init_keystore(keys)
   c.expiry_time = 900
end
```

# Signing

```ruby
generator = SimpleSignature::Generator.new(key) do |g|
  g.include method, path, query_string, body
end
```

```ruby
generator = SimpleSignature::Generator.new(key) do |g|
  g.include 'some text'
  g.include 'more text'
  ...
end
```

```ruby
generator.signature
generator.timestamp
generator.auth_hash
generator.auth_params
```

# Validating

```ruby
validator = SimpleSignature::Validator.new(key, signature, timestamp) do |v|
  v.include 'some text here'
  v.include 'some more text'
end
```

```ruby
# This class will validate a request method, path, query_string and body
validator = SimpleSignature::RequestValidator.new(request)
```

```ruby
validator.success? # true or false
validator.error.code
validator.error.message
```
