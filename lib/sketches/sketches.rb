#
#--
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
#Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'sketches/config'
require 'sketches/cache'

module Sketches
  #
  # Configure Sketches with the given _options_.
  #
  # _options_ may contain the following keys:
  # <tt>:tmpdir</tt>:: Directory to store temporary sketches in.
  #                    Defaults to Dir.tmpdir if unspecified.
  # <tt>:term</tt>:: The terminal to optionally run the editor within.
  # <tt>:editor</tt>:: The editor to use to edit sketches.
  # <tt>:pause</tt>:: The number of seconds to pause in-between
  #                   checking if any sketches were modified.
  #
  #   Sketches.config :editor => 'gvim', :pause => 2
  #
  #   Sketches.config :editor => 'vim', :term => lambda { |cmd|
  #     "xterm -fg gray -bg black -e #{cmd.dump} &"
  #   }
  #
  def Sketches.config(options={})
    if options[:tmpdir]
      Config.tmpdir = options[:tmpdir]
    end

    if options[:term]
      Config.term = options[:term]
    end

    if options[:editor]
      Config.editor = options[:editor]
    end

    if options[:pause]
      Config.pause = options[:pause]
    end

    return nil
  end

  @@sketches_cache = nil

  #
  # The cache of sketches.
  #
  def Sketches.cache
    unless @@sketches_cache
      @@sketches_cache = Cache.new
    end

    return @@sketches_cache
  end

  #
  # Edits the sketch with the specified _id_or_name_. If no sketch exists
  # with the specified _id_or_name_, one will be created.
  #
  #   Sketches.sketch 2
  #
  #   Sketches.sketch :foo
  #
  def Sketches.sketch(id_or_name)
    Sketches.cache.synchronize do
      sketch = Sketches.cache[id_or_name]
      sketch ||= Sketches.cache.new_sketch(id_or_name)

      sketch.synchronize { sketch.edit }
    end
  end

  #
  # Creates a new sketch using the specified _path_.
  #
  #   Sketches.from 'path/to/foo.rb'
  #
  def Sketches.from(path)
    Sketches.cache.synchronize do
      sketch = Sketches.cache.reuse_sketch(path)

      sketch.synchronize { sketch.edit }
    end
  end

  #
  # Names the sketch with the specified _id_ with the specified _name_.
  #
  #   Sketches.name 2, :foo
  #
  def Sketches.name(id,name)
    Sketches.cache.synchronize do
      Sketches.cache.name_sketch(id,name)
    end
  end

  #
  # Saves the sketch with the specified _id_or_name_ to the specified
  # _path_.
  #
  #   Sketches.save 2, 'path/to/example.rb'
  #
  #   Sketches.save :foo, 'path/to/foo.rb'
  #
  def Sketches.save(id_or_name,path)
    Sketches.cache.synchronize do
      if (sketch = Sketches.cache[id_or_name])
        sketch.save(path)
      end
    end
  end

  #
  # Print out all of the sketches.
  #
  def Sketches.print
    Sketches.cache.synchronize { puts Sketches.cache }
  end
end
