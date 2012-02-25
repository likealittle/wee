module Wee
  module Widget
    class Container < Wee::Component
      def initialize
        @children = []
      end

      def add(child)
        if (child.nil?) 
          raise "child is nil"
        end

        if (!child.is_a?(Wee::Component))
          raise "you can only add a Wee::Component to a container, not a #{child.inspect}"
        end

        @children << child
        self
      end

      def empty
        @children == []
      end

      def remove_all
        @children = []
      end

      def render(r)
        r.span.with {
          @children.each { |c|
            r.render c
          }
        }
      end

      def children
        puts "chilren being called"
        @children
      end
    end
  end
end
