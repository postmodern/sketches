#
#--
# Sketches - A Ruby library for live programming.
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
#Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'sketches/exceptions/unknown_sketch'
require 'sketches/config'
require 'sketches/sketch'

require 'thread'

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

        return self[id] = Sketch.new(id,:name => name)
      end
    end

    #
    # Creates a new sketch using the existing _path_.
    #
    #   reuse_sketch 'path/to/foo.rb'
    #
    def reuse_sketch(path)
      id = next_id

      return self[id] = Sketch.new(id,:path => path)
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
      elsif (id_or_name.kind_of?(String) || id_or_name.kind_of?(Symbol))
        return find_by_name(id_or_name)
      end
    end

    alias each_sketch each_value

  end
end
