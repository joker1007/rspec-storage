begin

  require "googleauth"
  require "google/apis/storage_v1"
  require "tempfile"
  require "delegate"

  require "rspec/storage/fake_io"

  module RSpec
    module Storage
      module GCS
        RSpec::Storage.register("gs", self)

        SCOPES = ["https://www.googleapis.com/auth/devstorage.read_write"].freeze

        class << self
          def handle_location(uri)
            client = Google::Apis::StorageV1::StorageService.new
            auth = Google::Auth.get_application_default(SCOPES)
            client.authorization = auth
            FakeIO.new(Uploader.new(client, uri))
          end
        end

        class Uploader < Delegator
          def initialize(gcs_client, uri)
            @tempfile = Tempfile.new("rspec-storage-gcs")
            @gcs_client = gcs_client
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
            object = Google::Apis::StorageV1::Object.new(name: @key)
            @gcs_client.insert_object(@bucket, object, upload_source: @tempfile)
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
