require 'colorize'

module Debug

	@@iteration = 1

	def self.on()
		set_trace_func proc { |event, file, line, id, binding, classname|
			if (event == "call" or event == "return") and classname != nil and classname.included_modules.include?(Debug)
				puts "#{'[DEBUGGER]'.red} (#{@@iteration}) #{event} method: #{id.to_s.light_blue}, from class: #{classname.to_s.green}."
				@@iteration += 1
			end
		}
	end

	def self.off()
		set_trace_func nil
	end

end