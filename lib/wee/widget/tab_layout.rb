module Wee
  module Widget
    class TabLayout < Wee::Component
      def initialize
        super
        @hl = HorizontalLayout.new
        @menu_l = VerticalLayout.new

        @current_view_container = Container.new
        @hl.add(@menu_l)
        @hl.add(@current_view_container)
        @menus = {}
      end

      def add(child, name)
        puts "adding this child to tab layout"
        l = Button.new.text(name) 
        l.onclick {
          puts "setting current view to #{name}"
          set_current_view(child)
        }

        @menu_l.add(l)
        self
      end

      def set_current_view(view)
        @current_view_container.remove_all
        @current_view_container.add(view)
      end

      def render(r)
        r.render(@hl)
      end

      def children
        [@hl]
      end
    end
  end
end
