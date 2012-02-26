module Wee
  module Widget
    class Container < Wee::Component
      def initialize
        @children = []
      end

      def add_one(child)
        if (child.nil?) 
          raise "child is nil"
        end

        if (!child.is_a?(Wee::Component))
          raise "you can only add a Wee::Component to a container, not a #{child.inspect}"
        end

        @children << child
        self
      end

      def add_all(*args)
        p "adding all: #{args.inspect}"
        args.each { |c|
          add_one(c)
        }
        self
      end

      def add(*args)
        add_all(*args)
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
        @children
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
