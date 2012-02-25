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

      def render_click_handler(r, t)
        if t.nil?
          raise "t cannot be nil in render_click_handler"
        end

        if click_handlers.size > 0
          puts "actually adding a click handler"

          # t.onclick_javascript("this.form.last_clicked.value = '#{t.get_oid}'; this.form.submit()")

          t.onclick_callback {
            run_click_handlers
          }
        end
        self
      end

      def run_click_handlers
        click_handlers.each { |c|
          c.call
        }
      end
    end
  end
end
