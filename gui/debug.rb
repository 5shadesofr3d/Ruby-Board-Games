require 'colorize'

module Debug

	@@iteration = 1
	@@enabled = false

	def self.on()
		@@enabled = true
		set_trace_func proc { |event, file, line, id, binding, classname|
			if (event == "call" or event == "return") and classname != nil and classname.included_modules.include?(Debug)
				puts "#{'[DEBUGGER]'.red} (#{@@iteration}) #{event} method: #{id.to_s.light_blue}, from class: #{classname.to_s.green}."
				@@iteration += 1
			end
		}
	end

	def self.off()
		@@enabled = false
		set_trace_func nil
	end

	def self.enabled()
		return @@enabled
	end

end