require_relative 'sample_elevator'
require_relative 'dude'

e = SampleElevator.new('foo', 0.5, 10, 10)
elevators = [e]

script = {
  2 => [
    # [:add_people, 5, 3],
    [:spawn_dude, 5, 7],
    [:called_at, 5],
  ],
  # 3 => [[:called_at, 4]],
}

queues = {}

def each_dude_in(queues, &block)
  queues.values.each{ |queue_on_floor| queue_on_floor.each{ |dude| yield dude } }
end

15.times do |time|
  puts "=== #{time.to_s.rjust(3)}"

  # Running script
  events = script[time]
  unless events.nil?
    events.each do |event|
      case event.first
      when :called_at
        puts "! called at #{event.last}"
        elevators.each do |elevator|
          elevator.called_at(event.last)
        end
      when :add_people
        num = event[2]
        floor = event[1]
        puts "! #{num} people arrived at floor #{floor}"
        queues[floor] ||= 0
        queues[floor] += num
      when :spawn_dude
        from_floor = event[1]
        to_floor = event[2]
        puts "! spawned dude: #{from_floor} -> #{to_floor}"
        queues[from_floor] ||= []
        queues[from_floor] << Dude.new(from_floor, to_floor, time)
      end
    end
  end

  # Dudes actions
  each_dude_in(queues){ |dude| dude.act(time, elevators) }

  # Elevato commands
  elevators.each do |elevator|
    elevator.process(time)
    puts " #{elevator.name} #{elevator.status} at #{elevator.position} (#{elevator.instruction})"

    puts "#{elevator.name} stopped at #{elevator.position.to_i}" if (elevator.position % 1 == 0) && elevator.idle?
  end

end
