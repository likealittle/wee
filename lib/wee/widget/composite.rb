require "wee/widget/widget_dsl"
module Wee
  module Widget
    # a widget that is created from other widgets.
    class Composite < Wee::Component
      include WidgetDsl

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

      def handle
        children.each { |c|
          if c.respond_to? :handle
            c.handle
          end
        }
      end
    end
  end
end
