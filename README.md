# Installation

Add it to your gemfile with:

```ruby
  gem 'simple_signature', git: 'git@github.com:workshare/simple-signature-ruby.git'
```

# Configuration

You may use a file, for example `/config/initializers/simple_signature.rb` with contents:

```ruby
  SimpleSignature.configure do |c|
    c.init_keystore(keys)  
    c.expiry_time = 900                   # default is 900
    c.key_param_name = 'sigkey'           # default is 'sigkey'
    c.signature_param_name = 'signature'  # default is 'signature'
    c.timestamp_param_name = 'timestamp'  # default is 'timestamp'
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
file_path = File.join("config", "keystore.yml")
file_path = File.join("config", "keystore-sample.yml") unless File.exist?(file_path)

keys = YAML.load_file(file_path)

SimpleSignature.configure do |c|
   c.init_keystore(keys)
end
```

# Signing

Use `include` to add strings to the final payload to be signed. You can separate several strings with commas or in different lines. Examples:

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

You can use the generator without a block too:

```ruby
generator = SimpleSignature::Generator.new(key)

generator.include method, path, query_string, body
generator.include 'more text here', 'even more'

generator.include_query {:x => 1, :a => 2}  # You can pass a Hash
generator.include_query 'x=1&a=2'   # Or a query string. Will be sorted.

generator.reset!  # to clean the previous data and prepare the generator for a new signature
```

After succesfully generating a signature, you can access the relevant information needed to validate this signature in the future, with the following methods.

```ruby
generator.signature
generator.timestamp
generator.auth_hash     # a Hash containing the signature key, signature and timestamp
generator.auth_params   # a query string representation of the auth_hash, ready for inclusing in a URL query params
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

# In case of error (success = false)
validator.error.code
validator.error.message
```
