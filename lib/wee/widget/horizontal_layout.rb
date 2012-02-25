module Wee
  module Widget
    class HorizontalLayout < Container
      def render(r)
        r.table {
          r.table_row {
            @children.each { |c|
              r.table_data {
                r.render c
              }
            }
          }
        }
      end
    end
  end
end
