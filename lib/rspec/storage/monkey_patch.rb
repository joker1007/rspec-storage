require "rspec/core/formatters"
require "rspec/core/reporter"
require "uri"

module RSpec
  module Storage
    class UnknownSchemeProvider < StandardError; end

    module FormattersLoaderExtension
      private

      if Gem::Version.new(RSpec::Core::Version::STRING) >= Gem::Version.new("3.6.0")
        method_name = "open_stream"
      else
        method_name = "file_at"
      end

      define_method(method_name) do |path|
        uri = URI.parse(path)
        if uri.scheme
          if provider = RSpec::Storage.providers[uri.scheme]
            provider.handle_location(uri)
          else
            raise UnknownSchemeProvider
          end
        else
          super(path)
        end
      end
    end

    module ReporterExtension
      def close
        super
        registered_listeners(:close).each do |formatter|
          output = formatter.output
          next unless output.is_a?(FakeIO)
          output.close unless output.closed?
        end
      end
    end
  end
end

RSpec::Core::Formatters::Loader.prepend(RSpec::Storage::FormattersLoaderExtension)
RSpec::Core::Reporter.prepend(RSpec::Storage::ReporterExtension)
