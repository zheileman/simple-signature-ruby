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
