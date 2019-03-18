require 'state_pattern'

# For reference, these are the methods available in state_pattern.
class BaseState < StatePattern::State

  # Called when entering the state. Note: Name cannot change!
  def enter

  end

  # Defines how to transition to a new state. Note: You can change the name,
  # but you should leverage polymorphism to call functions since they all inherit State.
  # Ex) state_machine.change_state
  #
  # The only issue with this module is that you need to tell a state which other state
  # to transition into.
  def change_state
    # transition_to(another_state)
  end

  # Defines what this state should do. Note: You can change the name,
  # but you should leverage polymorphism to call functions since they all inherit State.
  # Ex) state_machine.execute
  def execute

  end

  # Called when leaving the state. Note: Name cannot change!
  def exit

  end

end

class BaseStateMachine

end

# Here's an example implementation of the state pattern
# taken from their documentation.
class Stop < StatePattern::State
  def next
    sleep 3
    transition_to(Go)
  end

  def color
    "Red"
  end
end

class Go < StatePattern::State
  def next
    sleep 2
    transition_to(Caution)
  end

  def color
    "Green"
  end
end

class Caution < StatePattern::State
  def next
    sleep 1
    transition_to(Stop)
  end

  def color
    "Amber"
  end
end

class TrafficSemaphore
  include StatePattern
  set_initial_state Stop
end

semaphore = TrafficSemaphore.new

loop do
  puts semaphore.color
  semaphore.next
end