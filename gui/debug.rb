require 'colorize'

module Debug

	def self.on()
		set_trace_func proc { |event, file, line, id, binding, classname|
			if (event == "call" or event == "return") and classname != nil and classname.included_modules.include?(Debug)
				puts "#{'[DEBUGGER]'.red} #{event} method: #{id.to_s.light_blue}, from class: #{classname.to_s.green}."
			end
		}
	end

	def self.off()
		set_trace_func nil
	end

end