class WidgetBuilder < Wee::Widget::TabLayout
  include Wee::Widget

  attr_accessor :count

  def initialize
    super
    puts "initializing widget builder"
    add_decoration Wee::StyleDecoration.new(self)

    @tab1 = VerticalLayout.new
    @tb1 = TextBox.new.text("click test to double")
    @tb2 = Button.new.text("test")
    @tab1.add(Label.new.text("type text and click test"))
    @tab1.add(@tb1)
    @tab1.add(@tb2)

    @tb2.onclick {
      puts "callback called"
      @tb1.text(@tb1.get_text + @tb1.get_text)
    }

    @tab2 = Container.new.add(@label1 = Label.new.text("second tab")).add(@textbox = TextBox.new.text("can be clicked"))

    add(@tab1, "Tab 1")
    add(@tab2, "Tab 2")

    @textbox.onclick {
      @textbox.text = "is clicked"
    }
    
    @textbox.onclick {
      @label1.text = "aha, second callback"
    }
  end

  def style
    ".wee-Counter a { border: 1px dotted blue; margin: 2px; }"
  end
end
