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
    end
  end
end
