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
        r.div.with {
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
