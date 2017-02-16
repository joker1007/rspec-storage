require "forwardable"

module RSpec
  module Storage
    class FakeIO < IO
      extend Forwardable

      def initialize(obj)
        @obj = obj
      end

      def_delegators :@obj, *IO.public_instance_methods(false)
    end
  end
end
