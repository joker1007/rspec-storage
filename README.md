# rspec-storage

RSpec output test report to any stroage

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-storage'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-storage

# Support Storages

- S3 (s3://)
- GCS (gs://)

# Environment Variables

- S3
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_REGION

- GCS
  - GOOGLE_APPLICATION_CREDENTIALS

## Usage

```
$ rspec -r rspec/storage spec/example_spec.rb -f doc -f json s3://your-bucket/spec_result.json
```

You need to require `rspec/storage` before rspec init process

## With webmock

If you use webmock, you may need to add snippet to spec_helper as workaround.

```ruby
RSpec.configure do |config|
# ...

  config.after :suite do
    WebMock.allow_net_connect!
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joker1007/rspec-storage.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

