module Wee
  module Widget
    # a widget that is created from other widgets.
    class RootComposite < Wee::RootComponent
      include WidgetDsl
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
        r.hidden_input.name("last_clicked")
        r.form.enctype_multipart.with do
          r.render @child
        end
      end

      def process_callbacks(*args)
        ret = super(*args)
        if (@child.respond_to? :handle)
          @child.handle
        end
        ret
      end
    end
  end
end
