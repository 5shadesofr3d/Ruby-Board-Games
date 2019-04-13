module Board
	class Controller < Qt::Object
		include Test::Unit::Assertions
		include Debug
		
		attr_reader :animation
		
		slots :onDrop
		signals :translateStarted, :translateCompleted, :dropped

		def initialize(parent: nil)
			parent != nil ? super(parent) : super()
			setupAnimation()
		end

		def setupAnimation()
			@animation = Qt::PropertyAnimation.new(self)
			connect(animation, SIGNAL("finished()"), self, SIGNAL("translateCompleted()"))
		end

		def self.clear(model)
			model.each(:tile) {|tile| tile.detach }
		end

		def drop(
			chip_model: nil, chip_view: nil,
			board_model: nil, board_view: nil,
			column: 0, time: 750)
			
			assert (chip_model.is_a?(Model::Chip) or chip_model.nil?)
			assert (chip_view.is_a?(View::Chip) or chip_view.nil?)
			assert column.is_a? Integer
			assert column >= 0
			
			connect(self, SIGNAL("translateCompleted()"), self, SLOT("onDrop()"))

			chip_view.update(chip_model) unless chip_view.nil?

			unless chip_model.nil? or board_model.nil?
				translate_model(item: chip_model, from: board_model.head(column), to: board_model.next_empty(column))
			end
			unless chip_view.nil? or board_view.nil?
				translate_view(item: chip_view, from: board_view.head(column), to: board_view.next_empty(column), time: time)
			end
		end

		def onDrop()
			dropped
			disconnect(self, SIGNAL("translateCompleted()"), self, SLOT("onDrop()"))
		end

		def translate_model(item: nil, from: nil, to: nil)
			assert item.is_a?(Model::Chip)
			assert from.is_a?(Model::Tile)
			assert to.is_a?(Model::Tile)

			from.detach(destroy_view: false)
			to.attach(item)
		end

		def translate_view(item: nil, from: nil, to: nil, time: 0)
			assert item.is_a?(View::Chip)
			assert from.is_a?(View::Tile)
			assert to.is_a?(View::Tile)
			assert time.is_a?(Integer) and time >= 0

			from.detach(destroy_view: false)
			to.attach(item)

			animation.targetObject = item
			animation.propertyName = "geometry"
			animation.duration = time
			animation.startValue = from.geometry
			animation.endValue = to.geometry

			translateStarted

			animation.start
		end
	end
end