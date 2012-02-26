module Wee
  module Widget
    module ClickHandler

      def click_handlers
        @click_handlers ||= []
      end

      def handle
        handler.handle
      end

      def handler
        @handler ||= Handler.new
      end

      def onclick
        click_handlers << lambda { yield }
        self
      end

      def render_pre_click_handler(r)
        @pre_click_rendered = true
        if (click_handlers.size > 0)
          # render a hidden tag
          @click_handler_hidden_tag = r.hidden_input
          @click_handler_hidden_tag.oid.callback_method(:my_click_callback)
          @click_handler_hidden_oid = @click_handler_hidden_tag.get_oid
        end
      end

      def render_click_handler(r)
        render_pre_click_handler(r)
        t = yield
        render_after_click_handler(r, t)
      end

      def my_click_callback(*args)
        puts "my click callback called for #{self.inspect}"
        if (args[0] == "true") 
          # we are clicked
          puts "is clicked is true! for #{self.inspect}"
          @is_clicked = nil
          handler.add {
            run_click_handlers
          }
        end
      end

      def render_after_click_handler(r, t)
        if t.nil?
          raise "t cannot be nil in render_click_handler"
        end

        raise "pre click handler wasn't called" if @pre_click_rendered.nil?

        if click_handlers.size > 0
          puts "actually adding a click handler"

          t.onclick_javascript("document.getElementById('#{@click_handler_hidden_oid}').value = 'true'; wee.post_callback()")
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
