#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

require_relative 'engine'

options = OpenStruct.new
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: master.rb elevator_file script_file"

  opts.on("--seed SEED", Integer, "Randomization seed") do |seed|
    options.seed = seed
  end
end
optparse.parse!

if ARGV.size < 2
  puts optparse
  exit(-1)
end

def singularize(num, word)
  (num == 1) ? "#{num} #{word.singularize}" : "#{num} #{word}"
end

begin
  engine = Engine.new(ARGV[0], ARGV[1], options)
  engine.run

  puts
  puts " Simulation finished ".center(70, '*')
  puts "Randomized with seed #{engine.seed}" if engine.random?
  puts "#{singularize(engine.arrived.count, 'people')} arrived at destination"
  puts "#{singularize(engine.travelling.count, 'people')} still travelling"
  puts "#{singularize(engine.waiting.count, 'people')} still waiting for an elevator"
  puts "Score: #{engine.arrived.count * 2 - engine.travelling.count - engine.waiting.count * 2}"
rescue ArgumentError => e
  puts "ERROR: #{e.message}"
  puts optparse
  exit(-1)
end
