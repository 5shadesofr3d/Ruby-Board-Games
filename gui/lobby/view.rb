require 'Qt'
require 'test/unit'

require_relative '../player/online_player'
require_relative '../player/abstract_player'
require_relative '../player/local_player'
require_relative '../player/ai_player'

module Lobby
  module Color
    GREY = "#D8DAE7"
    BLACK = "#050D10"
    LIGHT_BLUE = "#18CAE6"
    BLUE = "#34608D"
    DARK_BLUE = "#0D0C1C"
  end

  class View < Qt::Frame
    attr_reader :table, :buttons

    slots :add,:pop

    @@MAX_ITEM_COUNT = 4

    def initialize(parent: nil)
      parent != nil ? super(parent) : super()

      @table = Table.new(parent: self)
      @buttons = ButtonPanel.new(parent: self)
      @item_count = 0

      setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Minimum)
      setMaximumWidth(550)
      setMaximumHeight(400)

      layout = Qt::VBoxLayout.new(self)
      layout.addWidget(table)
      layout.addWidget(buttons)
      layout.setAlignment(buttons, Qt::AlignHCenter | Qt::AlignBottom)
      setLayout(layout)

      connect(buttons.add, SIGNAL("clicked()"), self, SLOT(:add))
      connect(buttons.remove, SIGNAL("clicked()"), self, SLOT(:pop))
      setStyleSheet("background-color:#{Color::DARK_BLUE}; border: 1px; border-radius: 10px")
    end

    def add()
      if @item_count < @@MAX_ITEM_COUNT
        @table.add()
        @item_count += 1
      end
    end

    def pop()
      if @item_count > 1
        @table.pop()
        @item_count -= 1
      end
    end

    def setAll(items)
      items.each { |item| self.add() if @item_count != items.size }
      populate(items)
    end

    def getAll()
      items = []
      @table.rows.each {|info| items << info.construct(parent) }
      return items
    end

    def populate(items)
      @table.rows.each_with_index do |row, i|
        item = items[i]
        row.name = item.name
        row.color = item.color
        row.type = item.class
        row.wins = item.wins
        row.losses = item.losses
        row.ties = item.ties
      end
    end

  end

  class ButtonPanel < Qt::Widget
    attr_reader :add, :start, :exit, :remove

      def initialize(parent: nil)
      parent != nil ? super(parent) : super()

      buttonLayout = Qt::HBoxLayout.new(self)
      @add = Button.new("Add", self)
      @start = Button.new("Start", self)
      @exit = Button.new("Exit",self)
      @remove = Button.new("Remove",self)
      buttonLayout.addWidget(exit)
      buttonLayout.addWidget(add)
      buttonLayout.addWidget(remove)
      buttonLayout.addWidget(start)
      setLayout(buttonLayout)

    end

  end

  class Button < Qt::PushButton
    def initialize(str, parent)
      super(str, parent)

      setStyleSheet("color:white; background-color:#{Color::BLUE}; border: 1px; border-radius: 10px")

      setMaximumSize(75, 50)
      setMinimumSize(75, 50)

      font = self.font()
      font.setPixelSize(17)
      self.setFont(font)
    end
  end

  class Table < Qt::Frame
    include Test::Unit::Assertions

    attr_reader :rows

    def initialize(parent: nil)
      parent != nil ? super(parent) : super()

      @rows = []
      @layout = Qt::VBoxLayout.new(self)
      setLayout(@layout)

      setSizePolicy(Qt::SizePolicy::Preferred, Qt::SizePolicy::Maximum)

      addHeader

      assert valid?
    end

    def addHeader()
      assert valid?

      @layout.addWidget(Header.new(parent: self))

      assert valid?
    end

    def add()
      assert valid?

      row = TableRow.new(parent: self)
      @rows << row
      @layout.addWidget(row)

      assert row.is_a? TableRow
      assert valid?
    end

    def pop()
      assert valid?
      assert @rows.count > 0
      
      row = @rows.pop
      row.close
      @layout.removeWidget(row)

      assert valid?
    end

    def valid?()
      return false unless @rows.is_a?(Array)
      return false unless @layout.is_a?(Qt::VBoxLayout)

      @rows.each {|pi| return false unless pi.is_a?(TableRow)}

      return true
    end

  end

  class Label < Qt::Label
    def initialize(str, parent)
      super(str, parent)
      setAlignment(Qt::AlignCenter)

      font = self.font()
      font.setPixelSize(17)
      self.setFont(font)

      setMaximumWidth(30)
      setMinimumWidth(30)

      setStyleSheet("color:#{Color::GREY};")
    end
  end

  class LineEdit < Qt::LineEdit
    def initialize(str, parent)
      super(str, parent)
      font = self.font()
      font.setPixelSize(15)
      self.setFont(font)
      setAlignment(Qt::AlignCenter)
      setStyleSheet("color:#{Color::GREY};")
    end
  end

  class DropDownBox < Qt::ComboBox
    def initialize(parent)
      super(parent)
      font = self.font()
      font.setPixelSize(15)
      self.setFont(font)
      addItems(["Local", "Computer", "Online"])
      setStyleSheet("color:#{Color::GREY};")
    end
  end

  class ColorBox < Qt::Widget
    attr_accessor :color

    @@colors = ["red", "green", Color::LIGHT_BLUE, "yellow", "pink", "magenta"]

    def initialize(parent)
      super(parent)
      setMaximumSize(75, 30)
      setMinimumSize(75, 30)
      setColor
    end

    def updateColor
      setStyleSheet("background-color:#{@color};")
    end

    def setColor
      @color = @@colors.first
      updateColor
      @@colors.rotate!
    end

    def mousePressEvent(event)
      setColor
    end

  end

  class Header < Qt::Widget
    def initialize(parent: nil)
      parent != nil ? super(parent) : super()

      setMaximumHeight(50)
      setMinimumHeight(50)

      name = Label.new("Name", self)
      type = Label.new("Type", self)
      color = Label.new("Color", self)

      w = Label.new("W", self)
      l = Label.new("L", self)
      t = Label.new("T", self)

      font = name.font
      font.bold = true

      name.font = font
      type.font = font
      color.font = font
      w.font = font
      l.font = font
      t.font = font

      name.setMaximumWidth(100)
      name.setMinimumWidth(100)

      type.setMaximumWidth(100)
      type.setMinimumWidth(100)

      color.setMaximumWidth(75)
      color.setMinimumWidth(75)

      @layout = Qt::HBoxLayout.new(self)
      @layout.setSpacing(20)
      @layout.addWidget(name)
      @layout.addWidget(type)
      @layout.addWidget(color)
      @layout.addWidget(w)
      @layout.addWidget(l)
      @layout.addWidget(t)
      setLayout(@layout)

      setStyleSheet("background-color:#{Color::DARK_BLUE};")
    end
  end

  class TableRow < Qt::Widget
    include Test::Unit::Assertions

    def initialize(name: "Player", wins: 0, loss: 0, ties: 0, color: "blue", parent: nil)
      parent != nil ? super(parent) : super()
      assert wins.is_a? Integer
      assert loss.is_a? Integer
      assert ties.is_a? Integer
      assert wins >= 0
      assert loss >= 0
      assert ties >= 0

      setMaximumHeight(50)
      setMinimumHeight(50)

      @name = LineEdit.new(name, self)
      @type = DropDownBox.new(self)
      @color = ColorBox.new(self)
      @wins = Label.new(wins.to_s, self)
      @loss = Label.new(loss.to_s, self)
      @ties = Label.new(ties.to_s, self)
      setStyleSheet("background-color:#{Color::BLUE};")

      @name.setMaximumWidth(100)
      @name.setMinimumWidth(100)

      @type.setMaximumWidth(100)
      @type.setMinimumWidth(100)

      @layout = Qt::HBoxLayout.new(self)
      @layout.setSpacing(20)
      @layout.addWidget(@name)
      @layout.addWidget(@type)
      @layout.addWidget(@color)
      @layout.addWidget(@wins)
      @layout.addWidget(@loss)
      @layout.addWidget(@ties)
      setLayout(@layout)

      assert valid?
    end

    def close_all
      @layout.each {|e| e.hide}
    end

    def name=(str)
      @name.text = str
    end

    def name
      return @name.text
    end

    def color
      return @color.color
    end

    def color=(c)
      @color.color = c.name
      @color.updateColor
    end

    def type
      return @type.currentText
    end

    def type=(t)

      case t
      when LocalPlayer
        @type.currentIndex = 0
      when AIPlayer
        @type.currentIndex = 1
      when OnlinePlayer
        @type.currentIndex = 2
      end
    end

    def wins
      return @wins.text.to_i
    end

    def wins=(w)
      @wins.text = w
    end

    def losses
      return @loss.text.to_i
    end

    def losses=(l)
      @loss.text = l
    end

    def ties
      return @ties.text.to_i
    end

    def ties=(t)
      assert t.is_a? Integer
      assert t >= 0

      @ties.text = t
    end

    def construct(parent)
      # constructs and returns the item based off info
      assert type.is_a? String

      item = nil

      case type
      when "Local"
        item = LocalPlayer.new(self.name, self.color, parent: parent)
      when "Computer"
        item = AIPlayer.new(self.name, self.color, parent: parent)
      when "Online"
        item = OnlinePlayer.new(self.name, self.color, parent: parent)
      end

      return if item == nil

      item.wins = self.wins
      item.losses = self.losses
      item.ties = self.ties

      assert item.is_a? Player
      assert item.ties >= 0
      assert item.losses >= 0
      assert item.wins >= 0

      return item
    end

    def valid?
      # return false unless @name.is_a?(String)
      # return false unless @wins.is_a?(Integer) and @wins >= 0
      # return false unless @loss.is_a?(Integer) and @loss >= 0
      # return false unless @ties.is_a?(Integer) and @ties >= 0

      return true
    end
  end

end