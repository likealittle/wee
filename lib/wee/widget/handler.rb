module Wee
  module Widget
    class Handler
      def handlers
        @handlers ||= []
      end

      def add
        handlers << lambda { yield }
      end

      def handle
        handlers.each { |c|
          c.call
        }
        @handlers = []
      end
    end
  end
end
