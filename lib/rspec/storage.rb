require "rspec/storage/version"
require "rspec/storage/monkey_patch"

module RSpec
  module Storage
    class << self
      def providers
        @providers ||= {}
      end

      def register(scheme, klass)
        self.providers[scheme] = klass
      end
    end
  end
end

require "rspec/storage/s3"
require "rspec/storage/gcs"
