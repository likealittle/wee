module Wee
  module Widget
    # a widget that is created from other widgets.
    class RootComposite < Wee::RootComponent
      def initialize
        super
        @child = create
      end

      def title
        "override title in root component"
      end

      def create
        raise "you should override create"
      end

      def children
        [@child]
      end

      def render(r)
        r.form.enctype_multipart.with do
          r.render @child
        end
      end
    end
  end
end
