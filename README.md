# Helpling

We noticed a lot of repetition building up in our request specs. You had to
remember to set the correct content type and you could only set headers at
the time of the request. This meant you had to read a lot of noise to get
to the actual meaning of the test.

* No fuss, no pollution. Everything is contained in the `r` object which
  is a thin wrapper around the rails integration request helpers.
* Automatic JSON response parsing, so you don't have to.
* New `get_json`, `post_json`, `patch_json`, `put_json`, `delete_json`
  methods that work exactly as you'd expect.
* Everything you know about the request specs still applies. If we don't
  know how to handle it, we default back to the original implementation.

Helpling adds helpers you wish were built into RSpec's request specs.

## Usage

Automatic JSON response parsing when the content type is `application/json`.

``` ruby
json = JSON.parse(response.body)
expect(json).to eq({'mac_address' => '01:23:45:67:89:ab'})

# becomes...

expect(r.response.body).to eq({'mac_address' => '01:23:45:67:89:ab'})
```

Post JSON with the same convenience as form parameters.

``` ruby
post '/devices/v1', JSON.dump([{mac_address: '01:23:45:67:89:ab'}]), 'Content-Type' => 'application/json'

# becomes...

r.post_json '/devices/v1', [{mac_address: '01:23:45:67:89:ab'}]
```

Set headers once and reuse them in nested contexts.

``` ruby
context 'with authentication' do
  context 'and context 1' do
    it 'is truthy' do
      post '/path', {key: 'value'}, {'Authorization' => "Basic #{Base64.encode64(":secret")}"}
      # ...
    end
  end

  context 'and context 1' do
    it 'is truthy' do
      post '/path', {key: 'value'}, {'Authorization' => "Basic #{Base64.encode64(":secret")}"}
      # ...
    end
  end
end

# becomes...

context 'with authentication' do
  before do
    r.header 'Authorization', "Basic #{Base64.encode64(":secret")}"
  end

  context 'and context 1' do
    it 'is truthy' do
      r.post '/path', key: 'value'
      # ...
    end
  end

  context 'and context 2' do
    it 'is truthy' do
      r.post '/path', key: 'value'
      # ...
    end
  end
end
```

## Installation

First, add this line to your application's Gemfile.

``` ruby
group :test do
  gem 'helpling', github: 'tatey/helpling'
end
```

Then, install the gem.

```
$ bundle
```

Finally, require it in your spec helper (Typically, rails_helper.rb)

``` ruby
require 'helpling/rspec'
```

## Contributing

Feedback and patches welcome.

1. Fork it (https://github.com/tatey/helpling/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
