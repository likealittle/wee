module Wee
  module Widget
    module ClickHandler
      def click_handlers
        @click_handlers ||= []
      end

      def onclick
        click_handlers << lambda { yield }
        self
      end

      def render_click_handler(t)
        if click_handlers.size > 0
          puts "actually adding a click handler"
          t.onclick_javascript("this.form.submit()")
          t.callback {
            click_handlers.each { |c|
              c.call
            }
          }
        end

      end
    end
  end
end
