
require "wee/widget/click_handler"
module Wee
  module Widget
    class TextBox < Wee::Component
      include ClickHandler

      def initialize(str = nil)
        self.text = str || ""
      end

      def text=(str)
        @text = str
        self
      end

      def text
        @text ||= ""
      end

      def get_text
        text
      end

      def children
        []
      end

      def my_callback(*args)
        puts "text box callback"
        if (args.length == 1)
          @text = args[0]
        end
        super(*args)
      end

      def render(r)
        super(r)
        puts "rendering text box with value #{@text}"
        render_click_handler(r) {
          render_main(r).value(@text).callback_method(:my_callback)
        }
      end

      def render_main(r)
        r.text_input
      end
    end
  end
end
