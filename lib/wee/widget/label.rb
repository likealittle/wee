module Wee
  module Widget
    class Label < Wee::Component
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
        str
      end

      def get_text
        @text
      end
      
      def render(r)
        puts "rendering label with value #{@text}"
        t = r.span(@text)

        if @click_handler
          puts "actually adding a click handler"
          t.callback {
            puts "in here"
            @click_handler.call
          }
        end
      end
    end
  end
end
