
module Wee
  module Widget
    class TextBox < Wee::Component
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

      def onclick
        @click_handler = lambda { yield }
        self
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

        if @click_handler
          puts "actually adding a click handler"
          t.onclick_javascript("this.form.submit()")
          t.callback {
            puts "in here"
            @click_handler.call
          }
        end
      end

      def render_main(r)
        r.text_input
      end
    end
  end
end
