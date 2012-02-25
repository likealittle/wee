
require "wee/widget/click_handler"
module Wee
  module Widget
    class TextBox < Wee::Component
      include ClickHandler

      def initialize
        @text = ""
        @click_handler = nil
      end

      def text(str)
        @text = str
        self
      end

      def text=(str)
        text(str)
      end

      def get_text
        @text
      end

      def children
        []
      end

      def state(s)
        super
        s.add(@text)
      end

      def callback(value)
        @text = value
      end

      def render(r)
        puts "rendering text box with value #{@text}"
        t = render_main(r).value(@text).callback_method(:callback)
        render_click_handler(t)
      end

      def render_main(r)
        r.text_input
      end
    end
  end
end
