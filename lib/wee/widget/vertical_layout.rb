module Wee
  module Widget
    class VerticalLayout < Container
      def render(r)
        r.table.oid.with {
          @children.each { |c|
            r.table_row {
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
