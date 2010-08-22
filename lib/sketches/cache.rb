#
# Sketches - A Ruby library for live programming and code reloading.
#
# Copyright (c) 2009 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'sketches/exceptions/unknown_sketch'
require 'sketches/config'
require 'sketches/sketch'

require 'thread'

module Sketches
  class Cache < Hash

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

          sleep(Config.pause)
        end
      end
    end

    #
    # Determines if the cache is running.
    #
    # @return [Boolean]
    #   Specifies whether the cache is running.
    #
    def running?
      @thread.alive?
    end

    #
    # Provides thread-safe access to the cache.
    #
    # @yield []
    #   The given block will be ran when the cache is not being accessed
    #   by other threads.
    #
    # @return [nil]
    #
    def synchronize(&block)
      @mutex.synchronize(&block)
      return nil
    end

    #
    # Creates a new sketch.
    #
    # @param [Integer, Symbol, nil] id_or_name
    #   The optional ID or name of the new sketch.
    #
    # @return [Sketch]
    #   The new sketch.
    #
    # @example
    #   cache.new_sketch 2
    #
    # @example
    #   cache.new_sketch :foobar
    #
    def new_sketch(id_or_name=nil)
      id_or_name ||= next_id

      if id_or_name.kind_of?(Integer)
        return self[id_or_name] = Sketch.new(id_or_name)
      else
        id = next_id
        name = id_or_name

        return self[id] = Sketch.new(id,:name => name)
      end
    end

    #
    # Creates a new sketch from an existing path.
    #
    # @param [String]
    #   The path to the old sketch.
    #
    # @return [Sketch]
    #   The recycled sketch.
    #
    # @example
    #   reuse_sketch 'path/to/foo.rb'
    #
    def reuse_sketch(path)
      id = next_id

      return self[id] = Sketch.new(id,:path => path)
    end

    #
    # Finds and names a sketch.
    #
    # @param [Integer] id
    #   The ID of the sketch to name.
    #
    # @param [Symbol] name
    #   The name to give to the sketch.
    #
    # @return [Sketch]
    #   The newly named sketch.
    #
    # @raise [UnknownSketch]
    #   Could not find a sketch with the given ID.
    #
    # @example
    #   cache.name_sketch 1, :foobar
    #
    def name_sketch(id,name)
      id = id.to_i

      unless has_key?(id)
        raise(UnknownSketch,"cannot find the sketch with id: #{id}",caller)
      end

      sketch = self[id]
      sketch.synchronize { sketch.name = name.to_sym }

      return sketch
    end

    #
    # Finds a sketch with a given name.
    #
    # @param [Symbol] name
    #   The name to search for.
    #
    # @return [Sketch, nil]
    #   The sketch with the given name.
    #
    # @example
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
    # Finds a sketch in the cache.
    #
    # @param [Integer, Symbol] id_or_name
    #   The sketch ID or name to search for.
    #
    # @return [Sketch, nil]
    #   The sketch.
    #
    def [](id_or_name)
      if id_or_name.kind_of?(Integer)
        return super(id_or_name)
      elsif (id_or_name.kind_of?(String) || id_or_name.kind_of?(Symbol))
        return find_by_name(id_or_name)
      end
    end

    #
    # The next available sketch ID.
    #
    # @return [Integer]
    #   The next available sketch ID.
    #
    def next_id
      size + 1
    end

    alias each_sketch each_value

    #
    # Converts the sketch cache to a String.
    #
    # @param [Boolean] verbose
    #   Specifies whether verbose output should be generated.
    #
    # @return [String]
    #   A human readable representations of the cache.
    #
    def to_s(verbose=false)
      values.inject('') { |str,sketch| str << sketch.to_s(verbose) }
    end

  end
end
