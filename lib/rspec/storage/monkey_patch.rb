require "rspec/core/formatters"
require "rspec/core/formatters/base_formatter"
require "rspec/core/formatters/base_text_formatter"
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
  end
end

RSpec::Core::Formatters::Loader.prepend(RSpec::Storage::FormattersLoaderExtension)
