class Elevator
  class CapacityExceeded < RuntimeError; end
  class InvalidPosition < RuntimeError; end
  class SubclassConcern < RuntimeError; end
  class InvalidInstruction < RuntimeError; end

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

  # Callback: this is called at every loop, before instructions are processed
  def tick(time)
    raise SubclassConcern
  end

  # Callback: the elevator was called at a given floor
  def called_at(floor)
    raise SubclassConcern
  end

  # Callback: a button inside the elevator was pressed to go to a given floor
  def button_pressed(floor)
    raise SubclassConcern
  end

  ### YOU ARE NOT ALLOWED TO SUBCLASS ANYTHING BELOW THIS LINE ###

  def go_up
    @instruction = [:go_up]
  end

  def go_down
    @instruction = [:go_down]
  end

  def stop
    @instruction = [:stop]
  end

  def process(time)
    tick(time)

    unless @instruction.nil?
      case @instruction.first
      when :go_up
        raise InvalidPosition, 'I wish I could fly away' unless @position < floors
        @status = :moving_up
        @position += speed
        log "going up at #{position}"
      when :go_down
        raise InvalidPosition, "Everything's happy underground" unless @position > 0
        @status = :moving_down
        @position -= speed
        log "going down at #{position}"
      when :stop
        raise InvalidPosition, 'Cannot stop between floors' unless @position % 1 == 0
        @status = :idle
        log "stopped at #{position.to_i}"
      else
        raise InvalidInstruction, @instruction
      end
    else
      log 'doing nothing'
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


  private

  def log(message)
    puts "   #{name} [#{direction_symbol}] #{message}"
  end

  def direction_symbol
    case status
      when :idle then '='
      when :moving_up then '^'
      when :moving_down then 'v'
    end
  end

end
