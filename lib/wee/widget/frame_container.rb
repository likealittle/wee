module Wee
  module Widget
    # a container that can have only one child
    class FrameContainer < Container
      def set(child)
        remove_all
        add(child)
      end

      def add(child)
        if children.length > 0
          raise "too many children"
        end
        super(child)
      end

      def get_child
        children.first
      end
    end
  end
end
