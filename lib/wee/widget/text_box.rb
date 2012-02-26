
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
        newtext = nil
        if (args.length == 1)
          newtext = args[0]
        else
          return
        end

        if (@text != newtext and @ontextchange)
          handler.add {
            @ontextchange.call()
          }
        end

        @text = newtext
      end
      
      def ontextchange(component = nil)
        @ontextchange = lambda { yield }
        @ontextchange_component = component
      end

      def render(r)
        super(r)
        puts "rendering text box with value #{@text}"
        t = nil
        render_click_handler(r) {
          t = render_main(r).oid.value(@text).callback_method(:my_callback)
        }

        if @ontextchange
          # t.javascript_on(:keyup, "wee.post_callback(true)") 
          t.custom_update_component_on(:keyup, "wee.post_callback(true, true)", @ontextchange_component)
        end
      end

      def render_main(r)
        r.text_input
      end
    end
  end
end
