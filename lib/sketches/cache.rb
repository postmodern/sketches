require 'sketches/exceptions/unknown_sketch'
require 'sketches/config'
require 'sketches/sketch'

require 'mutex'

module Sketches
  class Cache < Hash

    # Seconds to wait between polling sketches
    PAUSE = 3

    #
    # Creates a new Sketches cache.
    #
    def initialize
      @mutex = Mutex.new

      super()

      @thread = Thread.new(self) do |cache|
        loop do
          cache.synchronize do
            cache.each_sketch do |sketch|
              sketch.synchronize do
                sketch.reload! if sketch.stale?
              end
            end
          end

          sleep(PAUSE)
        end
      end
    end

    #
    # Provides thread-safe access to the cache.
    #
    def synchronize(&block)
      @mutex.synchronize(&block)
      return self
    end

    #
    # Creates a new Sketch with the given _id_or_name_.
    #
    #   cache.new_sketch 2
    #
    #   cache.new_sketch :foobar
    #
    def new_sketch(id_or_name=nil)
      id_or_name ||= next_id

      if id_or_name.kind_of?(Integer)
        return self[id_or_name] = Sketch.new(id_or_name)
      else
        id = next_id
        name = id_or_name

        return self[id] = Sketch.new(id,name)
      end
    end

    #
    # Finds the sketch with the specified _id_ and gives it then
    # specified _name_.
    #
    #   cache.name_sketch 1, :foobar
    #
    def name_sketch(id,name)
      id = id.to_i

      unless has_key?(id)
        raise(UnknownSketch,"cannot find the sketch with id: #{id}",caller)
      end

      sketch = self[id]
      sketch.syncrhonize { sketch.name = name.to_sym }

      return sketch
    end

    #
    # Returns the sketch with the specified _name_.
    #
    #   cache.find_by_name :foobar
    #
    def find_by_name(name)
      name = name.to_sym

      each_value do |sketch|
        return sketch if sketch.name == name
      end

      return nil
    end

    #
    # Returns the sketch with the specified _id_or_name_.
    #
    def [](id_or_name)
      if id_or_name.kind_of?(Integer)
        return super(id_or_name)
      else
        return find_by_name(id_or_name)
      end
    end

    alias :each_value :each_sketch

  end
end
