require 'faker'

class Dude

  attr_reader :name, :current_floor, :destination_floor, :spawned_at, :elevator

  def initialize(current_floor, destination_floor, spawned_at)
    @name = Faker::Name.name
    @current_floor = current_floor
    @destination_floor = destination_floor
    @spawned_at = spawned_at
    @elevator = nil
  end

  def act(time, elevators)
    if waiting?
      puts "#{name} is on floor #{current_floor}, wants to go to floor #{destination_floor}"
      if available_elevator = find_available(elevators)
        board(available_elevator)
      end
    elsif on_elevator?
      puts "#{name} is on #{elevator.name}, going to floor #{destination_floor}"
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
      puts "#{name} boarded #{elevator.name}"
    end
  end

  def get_off
    elevator.remove_passenger(self)
    puts "#{name} got off #{elevator.name}"
    @current_floor = elevator.position.to_i
    @elevator = nil
  end

  def waiting?
    elevator.nil?
  end

  def on_elevator?
    !elevator.nil?
  end


  private

  def find_available(elevators)
    elevators.find{ |elevator| elevator.position == current_floor && elevator.can_be_boarded? }
  end

end
