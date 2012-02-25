module Wee
  module Widget
    class TabLayout < Composite
      def create
        @hl = HorizontalLayout.new
        @menu_l = VerticalLayout.new

        @hl.add(@menu_l)
        @hl.add(current_view_container)
        @menus = {}
        @hl
      end

      def current_view_container
        @current_view_container ||= Container.new
      end

      def add(child, name)
        @menus[name] = child
        if current_view_container.empty
          set_current_view(child)
        else
          generate_menus(get_current_view)
        end

        self
      end

      def generate_menus(current_view)
        @menu_l.remove_all
        @menus.each_pair { |name, child|
          puts "adding this child #{name} to tab layout"
          l = nil
          if (child != current_view)
            l = Link.new(name) 
            l.onclick {
              puts "setting current view to #{name}"
              set_current_view(child)
            }
          else 
            l = Label.new(name)
          end

          @menu_l.add(l)
        }
      end


      def get_current_view
        @current_view
      end

      def set_current_view(view)
        @current_view = view
        current_view_container.remove_all
        current_view_container.add(view)
        generate_menus(view)
      end
    end
  end
end
