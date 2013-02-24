require_relative 'sample_elevator'
require_relative 'dude'

e = SampleElevator.new('foo', 0.5, 10, 10)
elevators = [e]

script = {
  2 => [
    [:spawn_dude, 2, 4],
    [:spawn_dude, 2, 4],
  ],
  4 => [
    [:spawn_dude, 1, 2],
    [:spawn_dude, 1, 10],
  ],
  5 => [
    [:spawn_dude, 4, 0],
  ],
}

dudes = []

15.times do |time|

  puts "============ #{time.to_s.rjust(3)} ============"

  # Running script
  if events = script[time]
    events.each do |event|
      case event.first
      when :spawn_dude
        from_floor = event[1]
        to_floor = event[2]
        puts "! spawned dude: #{from_floor} -> #{to_floor}"
        dudes << Dude.new(from_floor, to_floor, time)
      end
    end
  end

  # Dudes actions
  dudes.each{ |dude| dude.act(time, elevators) }

  # Elevator commands
  elevators.each do |elevator|
    elevator.process(time)
  end

end

# Stats
arrived = dudes.select{ |dude| dude.arrived? }
travelling = dudes.select{ |dude| dude.on_elevator? }
waiting = dudes.select{ |dude| dude.waiting? }

puts
puts "*** Simulation finished ***"
puts "#{arrived.count} dudes arrived at destination"
puts "#{travelling.count} dudes still travelling"
puts "#{waiting.count} dudes still waiting for an elevator"
puts "Score: #{arrived.count * 2 - travelling.count - waiting.count * 2}"
