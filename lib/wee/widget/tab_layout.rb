module Wee
  module Widget
    class TabLayout < Composite
      def create
        @menus = {}
        puts "creating tab layout"
        w(:horizontal_layout, :name => :hl).add_all(
          w(:vertical_layout, :name => :menu_l),
          w(:container, :name => :current_view_container))
      end

      def current_view_container
        f(:current_view_container)
      end

      def add(child, name = nil)
        if (child.is_a? Hash)
          add_hash(child)
          return
        end

        if child.nil?
          raise "nil child for tab layout"
        end

        @menus[name] = child
        if current_view_container.empty
          set_current_view(child)
        else
          generate_menus(get_current_view)
        end

        self
      end

      def add_hash(hash)
        hash.each_pair { |k, v| 
          add(v, k)
        }
        self
      end

      def add_all(*args)
        raise "not supported"
      end

      def add_one(*args)
        raise "not supported"
      end

      def generate_menus(current_view)
        p "Current menus is #{@menus}"
        f(:menu_l).remove_all
        @menus.each_pair { |name, child|
          puts "adding this child #{name} to tab layout"
          l = nil
          if (child != current_view)
            l = w(:button, :text => name) 
            l.onclick {
              puts "setting current view to #{name}"
              set_current_view(child)
            }
          else 
            l = w(:label, :text => name)
          end

          f(:menu_l).add(l)
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
