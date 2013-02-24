require_relative 'sample_elevator'
require_relative 'dude'

e = SampleElevator.new('foo', 0.5, 10, 10)
elevators = [e]

script = {
  2 => [
    [:spawn_dude, 2, 4],
  ],
}

queues = {}

def each_dude_in(queues, &block)
  queues.values.each{ |queue_on_floor| queue_on_floor.each{ |dude| yield dude } }
end

15.times do |time|
  puts "============ #{time.to_s.rjust(3)} ============"

  # Running script
  events = script[time]
  unless events.nil?
    events.each do |event|
      case event.first
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
  end

end
