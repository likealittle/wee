$: << "../lib/"

require "wee"

class WidgetBuilder < Wee::Widget::RootComposite
  include Wee::Widget

  attr_accessor :count
  def initialize
 
#    add_decoration Wee::StyleDecoration.new(self)

    super
  end

  def create
    puts "initializing widget builder"

    w(:tab_layout, :name => :top).add(
      "Tab 1" => w(:vertical_layout).add(
        w(:text_box, :text => "click test to double", :name => :tb1),
        w(:button, :text => "test", :name => :tb2)),
      "Tab 2" => w(:container).add(
        w(:label, :name => :label1, :text => "second tab"),
        w(:text_box, :name => :textbox, :text => "can be clicked"),
        w(:text_box, :name => :textbox2, :text => "can also be clicked")),
      "Lazy tab 3" => lambda {
        res = w(:vertical_layout).add(w(:label, :text => rand().to_s), w(:button, :name => :dn))
        f(:dn).onclick { }
        res
      },
      "Autocomplete" => AutocompleteTest.new,
      "Table" => w(:tabular).add_row(Label.new("one"), Label.new("two")).add_row(Label.new("three"), Label.new("four"))

      )
    
    puts "creation done"

    f(:tb2).onclick {
      puts "callback called"
      f(:tb1).text = f(:tb1).text + f(:tb1).text
    }

    puts "on click handler now"

    f(:textbox).onclick {
      f(:textbox).text = "is clicked"
    }
    
    f(:textbox).onclick {
      f(:label1).text = "aha, second callback"
    }

    f(:textbox2).onclick {
      f(:textbox2).text = "nothing else should've changed!"
    }

    f(:top)
  end

  def style
    ".wee-Counter a { border: 1px dotted blue; margin: 2px; }"
  end
end

class AutocompleteTest < Wee::Widget::Composite
  def create
    r = w(:container).add(
      w(:text_box, :name => :t),
      w(:label, :name => :l))

    f(:t).ontextchange(f(:l)) {
      puts "TEXT CHANGED SUCKERS!"
      f(:l).text = "woo" + f(:t).text
    }
    r
  end
end

if __FILE__ == $0
  Wee.run(WidgetBuilder, port: 4000)
end
