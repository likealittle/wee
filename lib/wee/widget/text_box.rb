
require "wee/widget/click_handler"
module Wee
  module Widget
    class TextBox < Wee::Component
      include ClickHandler

      def initialize
        @text = ""
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
        s.add(@text)
        super
      end

      def callback(*args)
        if (args.length == 1)
          @text = args[0]
        end
      end

      def render(r)
        super(r)
        puts "rendering text box with value #{@text}"
        t = render_main(r).value(@text).callback_method(:callback)
        render_click_handler(r, t)
      end

      def render_main(r)
        r.text_input
      end
    end
  end
end
