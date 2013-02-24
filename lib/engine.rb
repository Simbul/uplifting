require 'i18n'
require 'active_support/all'

require 'person'
require 'elevator'

class Engine

  attr_reader :people

  def initialize(elevator_source, script_source, options)
    @elevator_source = elevator_source
    @script_source = script_source
    @options = options

    @elevator_class = elevator_class(elevator_source)
    @script_module = script_module(script_source)

    @people = []
    @prng = options.seed ? Random.new(options.seed) : Random.new
    @duration = @script_module::SIMULATION[:ticks]
    @elevators = @script_module::ELEVATORS.map { |name, params| @elevator_class.new(name, params[:ticks_per_floor], params[:capacity], params[:floors]) }
    @script = @script_module::SCRIPT
  end

  def run
    @duration.times do |time|

      puts " #{time.to_s.rjust(@duration.to_s.length)} ".center(70, '=')

      # Running script
      if declarative?
        if events = @script[:events][time]
          events.each do |event|
            case event.first
            when :spawn_person
              from_floor = event[1]
              to_floor = event[2]
              puts "! spawned person: #{from_floor} -> #{to_floor}"
              @people << Person.new(from_floor, to_floor, time)
            end
          end
        end
      elsif random?
        if @prng.rand < Script::SCRIPT[:spawn_ratio]
          from_floor = (@prng.rand * top_floor).round
          to_floor = (@prng.rand * top_floor).round
          puts "! spawned person: #{from_floor} -> #{to_floor}"
          @people << Person.new(from_floor, to_floor, time)
        end
      end

      # People actions
      @people.each{ |person| person.act(time, @elevators) }

      # Elevator commands
      @elevators.each do |elevator|
        elevator.process(time)
      end

    end
  end

  def declarative?
    @script[:type] == :declarative
  end

  def random?
    @script[:type] == :random
  end

  def seed
    @prng.seed
  end

  def arrived; @people.select{ |person| person.arrived? }; end
  def travelling; @people.select{ |person| person.on_elevator? }; end
  def waiting; @people.select{ |person| person.waiting? }; end


  private

  def elevator_class(elevator_source)
    require elevator_source
    klass = File.basename(elevator_source, '.rb').classify.constantize
    unless klass.superclass == Elevator
      raise ArgumentError, "Class #{klass} in #{elevator_source} should be a subclass of Elevator"
    end
    klass
  end

  def script_module(script_source)
    require script_source
    raise ArgumentError, "#{script_source} should contain a Script module" unless defined?(Script)
    Script
  end

  def top_floor
    @elevators.max{ |elevator| elevator.floors }.floors
  end

end
