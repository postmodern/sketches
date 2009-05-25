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

require 'sketches/config'
require 'sketches/temp_sketch'

require 'thread'

module Sketches
  class Sketch

    # ID of the sketch
    attr_reader :id

    # Optional name of the sketch
    attr_accessor :name

    # Last modification time of the sketch
    attr_reader :mtime

    #
    # Creates a new sketch object with the specified _id_ and the given
    # _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:name</tt>:: The name of the sketch.
    # <tt>:path</tt>:: The path to an existing sketch.
    #
    def initialize(id,options={})
      @id = id
      @name = options[:name]

      @mtime = Time.now
      @checksum = nil
      @mutex = Mutex.new

      if options[:path]
        @path = options[:path]
        @name ||= File.basename(@path)
      else
        TempSketch.open { |file| @path = file.path }
      end
    end

    #
    # Provides thread-safe access to the sketch.
    #
    def synchronize(&block)
      @mutex.synchronize(&block)
      return nil
    end

    #
    # Spawns the Sketches.editor with the path of the sketch.
    #
    def edit
      system(Config.editor.to_s,@path)
    end

    #
    # Returns +true+ if the sketch has become stale and needs reloading,
    # returns +false+ otherwise.
    #
    def stale?
      if File.file?(@path)
        if File.mtime(@path) > @mtime
          new_checksum = crc32

          if (@checksum.nil? || new_checksum != @checksum)
            return true
          end
        end
      end

      return false
    end

    #
    # Reloads the sketch.
    #
    def reload!
      if File.file?(@path)
        @mtime = File.mtime(@path)
        @checksum = crc32

        begin
          return load(@path)
        rescue LoadError => e
          STDERR.puts "#{e.class}: #{e.message}"
        end
      end

      return false
    end

    #
    # Returns the String representation of the sketch.
    #
    def to_s(verbose=false)
      str = @id.to_s
      str << ": #{@name}" if @name
      str << "\n\n"

      if File.file?(@path)
        File.open(@path) do |file|
          unless verbose
            4.times { str << "  #{file.read_line}" }
          else
            file.each_line { |line| str << "  #{line}" }
          end

          str << "\n"
        end
      end

      return str
    end

    protected

    #
    # Returns the CRC32 checksum of the sketch file.
    #
    def crc32
      r = 0xffffffff

      File.open(@path) do |file|
        file.each_byte do |b|
          r ^= b
          8.times { r = ((r >> 1) ^ (0xEDB88320 * (r & 1))) }
        end
      end

      return r ^ 0xffffff
    end

  end
end
