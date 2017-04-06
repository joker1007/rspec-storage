begin

  require "aws-sdk"
  require "tempfile"
  require "delegate"

  require "rspec/storage/fake_io"

  module RSpec
    module Storage
      module S3
        RSpec::Storage.register("s3", self)

        class << self
          def handle_location(uri)
            options = uri.query ? URI.decode_www_form(uri.query).map { |pair| pair.tap { |_p| _p[0] = _p[0].to_sym } }.to_h : {}
            client = Aws::S3::Client.new(options)
            FakeIO.new(Uploader.new(client, uri))
          end
        end

        class Uploader < Delegator
          def initialize(s3_client, uri)
            @tempfile = Tempfile.new("rspec-storage-s3")
            @s3_client = s3_client
            @uri = uri
            @bucket = uri.host
            @key = uri.path[1..-1]
          end

          def __getobj__
            @tempfile
          end

          def close
            @tempfile.flush
            @tempfile.rewind
            @s3_client.put_object(bucket: @bucket, key: @key, body: @tempfile)
            @s3_client.wait_until(:object_exists, bucket: @bucket, key: @key) do |w|
              w.max_attempts = 5
            end
            $stdout.puts "Upload to #{@uri.to_s}"
          ensure
            @tempfile.close
          end
        end
      end
    end
  end

rescue LoadError
end
