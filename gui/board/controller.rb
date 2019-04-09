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

		def drop(chip, col, model, time: 750)
			assert chip.is_a? Board::Model::Chip
			assert col.is_a? Integer
			assert col >= 0
			connect(self, SIGNAL("translateCompleted()"), self, SLOT("onDrop()"))
			
			translate(item: chip, from: model.head(col), to: model.next_empty(col), time: time)
		end

		def onDrop()
			dropped
			disconnect(self, SIGNAL("translateCompleted()"), self, SLOT("onDrop()"))
		end

		def translate(item: nil, from: nil, to: nil, time: 0)
			assert item.is_a?(Board::Model::Chip)
			assert from.is_a?(Board::Model::Tile)
			assert to.is_a?(Board::Model::Tile)
			assert time.is_a?(Integer) and time >= 0

			from.detach(destroy_view: false)
			to.attach(item)

			return if from == to or item.view == nil or from.view == nil or to.view == nil

			animation.targetObject = item.view
			animation.propertyName = "geometry"
			animation.duration = time
			animation.startValue = from.view.geometry
			animation.endValue = to.view.geometry

			translateStarted

			animation.start
		end
	end
end