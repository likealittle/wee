
require "wee/widget/click_handler"
require "wee/rightjs"

module Wee
  module Widget
    class TextBox < Wee::Component
      include ClickHandler

      def self.depends
        [Wee::RightJS]
      end

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

      def update_component_on_change(component)
        @update_component_on_change = [component, lambda { yield }]
      end

      def render(r)
        super(r)
        puts "rendering text box with value #{@text}"
        t = nil
        render_click_handler(r) {
          t = render_main(r).oid.value(@text).callback_method(:my_callback)
        }

        if (@update_component_on_change)
          t.update_component_on(:keyup, @update_component_on_change[0]) {
            @update_component_on_change[1].call
          }
        end
      end

      def render_main(r)
        r.text_input
      end
    end
  end
end
