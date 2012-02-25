module Wee
  module Widget
    class Container < Wee::Component
      def initialize
        @text = ""
        @children = []
      end

      def add(child)
        @children << child
        self
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
