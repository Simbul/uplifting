require 'elevator'

class SampleElevator < Elevator

  def initialize(*args)
    super
    @destination_floor = nil
  end

  def tick(time)
    stop if position == @destination_floor
  end

  def button_pressed(floor)
    @destination_floor = floor
    called_at(floor)
  end

  def called_at(floor)
    if idle?
      @destination_floor = floor
      go_up if position < floor
      go_down if position > floor
    end
  end

end
