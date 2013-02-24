require 'faker'

class Dude
  class InvalidAction < RuntimeError; end

  attr_reader :name, :current_floor, :destination_floor, :spawned_at, :elevator, :status

  def initialize(current_floor, destination_floor, spawned_at)
    @name = Faker::Name.name
    @current_floor = current_floor
    @destination_floor = destination_floor
    @spawned_at = spawned_at
    @elevator = nil
    @status = :idle
  end

  def act(time, elevators)
    if idle?
      elevators.each{ |elevator| elevator.called_at(current_floor) }
      @status = :waiting
      log "called elevator on floor #{current_floor}"
    elsif waiting?
      # log "is on floor #{current_floor}, waiting to go to floor #{destination_floor}"
      if available_elevator = find_available(elevators)
        board(available_elevator)
      end
    elsif on_elevator?
      # log "is on #{elevator.name}, going to floor #{destination_floor}"
      if elevator.position == @destination_floor && elevator.idle?
        get_off
      end
    end
  end

  def board(elevator)
    if elevator.can_be_boarded?
      elevator.add_passenger(self)
      @current_floor = nil
      @elevator = elevator
      @status = :travelling
      log "boarded #{elevator.name}"
      select_floor(destination_floor)
    end
  end

  def get_off
    elevator.remove_passenger(self)
    log "got off #{elevator.name}"
    @current_floor = elevator.position.to_i
    @elevator = nil
    @status = :arrived
  end

  def select_floor(floor)
    raise InvalidAction, 'Can only select floor when on elevator' if elevator.nil?
    elevator.button_pressed(floor)
    log "pressed button #{floor}"
  end

  def waiting?
    status == :waiting && elevator.nil?
  end

  def on_elevator?
    status == :travelling && !elevator.nil?
  end

  def idle?
    status == :idle
  end


  private

  def find_available(elevators)
    elevators.find{ |elevator| elevator.position == current_floor && elevator.can_be_boarded? }
  end

  def log(message)
    puts "#{name} #{message}"
  end

end
