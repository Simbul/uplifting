#!/usr/bin/env ruby

require 'optparse'
require 'i18n'
require 'active_support/all'

require_relative 'dude'
require_relative 'elevator'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: master.rb elevator_file"
end
optparse.parse!

if ARGV.empty?
  puts optparse
  exit(-1)
end

elevator_source = ARGV[0]
require_relative elevator_source
elevator_class = elevator_source.sub('.rb', '').classify.constantize

unless elevator_class.superclass == Elevator
  puts "Class #{elevator_class} in #{elevator_source} should be a subclass of Elevator"
  puts optparse
  exit(-1)
end

e = elevator_class.new('foo', 0.5, 10, 10)
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

def singularize(num, word)
  (num == 1) ? "#{num} #{word.singularize}" : "#{num} #{word}"
end

puts
puts "*** Simulation finished ***"
puts "#{singularize(arrived.count, 'dudes')} arrived at destination"
puts "#{singularize(travelling.count, 'dudes')} still travelling"
puts "#{singularize(waiting.count, 'dudes')} still waiting for an elevator"
puts "Score: #{arrived.count * 2 - travelling.count - waiting.count * 2}"
