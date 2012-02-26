module Wee
  module Widget
    # a widget that is created from other widgets.
    class RootComposite < Wee::RootComponent
      include WidgetDsl
      def initialize
        super
        @child = create
     #   add_decoration Wee::PageDecoration.new
        add_decoration Wee::FormDecoration.new
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
        r.javascript.with(File.open(File.dirname(__FILE__) + "/../jquery/jquery-1.3.2.min.js").read)
        r.javascript.with(File.open(File.dirname(__FILE__) + "/../jquery/wee-jquery.js").read)
        r.hidden_input.name("last_clicked")
        r.render @child
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
