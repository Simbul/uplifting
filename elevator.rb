class Elevator
  class CapacityExceeded < RuntimeError; end
  class InvalidPosition < RuntimeError; end
  class SubclassConcern < RuntimeError; end

  attr_accessor :name, :speed, :capacity, :floors
  attr_reader :status, :instruction, :position, :passengers

  def initialize(name, speed, capacity, floors, position=0)
    @name = name
    @speed = speed # floors per second
    @capacity = capacity
    @floors = floors
    @position = position # floors are the integers
    @status = :idle
    @instructon = nil
    @passengers = []
  end

  def go_up
    @instruction = [:go_up]
  end

  def go_down
    @instruction = [:go_down]
  end

  def stop
    @instruction = [:stop]
  end

  def called_at(floor)
    raise SubclassConcern
  end

  def tick(time)
    raise SubclassConcern
  end

  def button_pressed(floor)
    raise SubclassConcern
  end

  def process(time)
    tick(time)

    unless @instruction.nil?
      case @instruction.first
      when :go_up
        raise InvalidPosition, 'I wish I could fly away' unless @position < floors
        @status = :moving_up
        @position += speed
      when :go_down
        raise InvalidPosition, "Everything's happy underground" unless @position > 0
        @status = :moving_down
        @position -= speed
      when :stop
        raise InvalidPosition, 'Cannot stop between floors' unless @position % 1 == 0
        @status = :idle
      end
    end
  end

  def add_passenger(passenger)
    raise CapacityExceeded unless has_room?
    @passengers << passenger
  end

  def remove_passenger(passenger)
    @passengers.delete(passenger)
  end

  def idle?
    @status == :idle
  end

  def has_room?
    passengers.count < capacity
  end

  def can_be_boarded?
    has_room? && idle?
  end

end
