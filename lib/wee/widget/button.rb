module Wee
  module Widget
    class Button < TextBox
      def text(str)
        @text = str
        self
      end

      def render_main(r)
        r.submit_button
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
