class WidgetBuilder < Wee::Widget::RootComposite
  include Wee::Widget

  attr_accessor :count

  def create
    puts "initializing widget builder"
    add_decoration Wee::StyleDecoration.new(self)

    w(:tab_layout, :name => :top).add(
      "Tab 1" => w(:vertical_layout).add(
        w(:text_box, :text => "click test to double", :name => :tb1),
        w(:button, :text => "test", :name => :tb2)),
      "Tab 2" => w(:container).add(
        w(:label, :name => :label1, :text => "second tab"),
        w(:text_box, :name => :textbox, :text => "can be clicked"),
        w(:text_box, :name => :textbox2, :text => "can also be clicked"))
      )
    
    puts "creation done"

    f(:tb2).onclick {
      puts "callback called"
      @tb1.text = (@tb1.get_text + @tb1.get_text)
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
