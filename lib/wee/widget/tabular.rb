module Wee
  module Widget
    class Tabular < Wee::Component
      def initialize
        @rows = []
      end

      def add_row(*args)
        @rows << args
        self
      end


      def children
        @rows.flatten(1)
      end

      def handle
        children.each { |c|
          if c.respond_to? :handle
            c.handle
          end
        }
      end

      def render(r)
        r.table.oid.with {
          @rows.each { |row|
            r.table_row {
              row.each { |c|
                r.table_data {
                  r.render c
                }
              }
            }
          }
        }
      end
    end
  end
end
