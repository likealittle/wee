module Wee
  module Widget
    class Link < Container
      include ClickHandler

      def initialize(str = nil)
        super()
        if (str)
          self.text = str
        end
      end

      def text=(str)
        remove_all
        add(Label.new(str))
        self
      end

      def text
        children.first.get_text
      end

      def get_text
        text
      end

      def render(r)
        t = r.anchor
        render_click_handler(r, t)
        t.with {
          super(r)
        }
      end
    end
  end
end
