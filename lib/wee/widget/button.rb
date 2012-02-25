module Wee
  module Widget
    class Button < Wee::Component
      include ClickHandler

      def initialize(str = nil)
        if (str)
          puts "creating button with text #{str.inspect}"
          self.text = str
        end
      end

      def text=(str)
        @text = str
        self
      end

      def text
        @text ||= ""
      end

      def render(r)
        t = r.submit_button.value(text)
        render_click_handler(r, t)
      end

      def render_click_handler(r, t)
        if click_handlers.size > 0
          t.callback {
            run_click_handlers
          }
        end
      end
    end
  end
end
