module Wee
  module Widget
    # a widget that is created from other widgets.
    class Composite < Wee::Component
      def initialize
        super
        @child = create
      end

      def create
        raise "you should override create"
      end

      def children
        [@child]
      end

      def render(r)
        r.render @child
      end
    end
  end
end
