require "rspec/core/formatters"
require "rspec/core/reporter"
require "uri"

module RSpec
  module Storage
    class UnknownSchemeProvider < StandardError; end

    module FormattersLoaderExtension
      def file_at(path)
        uri = URI.parse(path)
        if uri.scheme
          if provider = RSpec::Storage.providers[uri.scheme]
            provider.handle_location(uri)
          else
            raise UnknownSchemeProvider
          end
        else
          super
        end
      end
    end

    module ReporterExtension
      def close
        super
        registered_listeners(:close).each do |formatter|
          output = formatter.output
          if output.respond_to?(:close) && output.respond_to?(:closed?)
            output.close if !output.closed? && output != $stdout && output != $stderr
          end
        end
      end
    end
  end
end

RSpec::Core::Formatters::Loader.prepend(RSpec::Storage::FormattersLoaderExtension)
RSpec::Core::Reporter.prepend(RSpec::Storage::ReporterExtension)
