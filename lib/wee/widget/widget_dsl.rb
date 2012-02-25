module Wee
  module Widget
    module WidgetDsl

      def camelize(s)
        s.split("_").collect { |i| i.capitalize }.join
      end

      def widgets
        @widget_dsl_widgets ||= []
      end

      def name_hash
        @widget_dsl_name_hash ||= {}
      end

      # name is a programmatic name, and will not show up in the external HTML
      def w(type, params = {})
        puts "creating #{type.inspect} with #{params.inspect}"
        klass = eval(camelize(type.to_s))
        widget = klass.new

        if (params[:name])
          name = params[:name]
        end

        if params[:text]
          widget.text = params[:text]
        end

        if (name)
          name_hash[name] = widget
        end
        puts "returning #{widget.inspect}"
        widget
      end

      def findByName(name)
        res = name_hash[name]
        if (res.nil?)
          raise "no widget found with name #{name}"
        end
        res
      end

      # alias for findByName
      def f(name)
        findByName(name)
      end
    end
  end
end
