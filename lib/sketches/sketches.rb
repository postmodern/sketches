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

require 'sketches/config'
require 'sketches/cache'

module Sketches
  #
  # Configure Sketches.
  #
  # @param [Hash] options
  #   Configuration options.
  #
  # @option options [String] :tmpdir (Dir.tmpdir)
  #   Alternate temp directory to store sketches in.
  #
  # @option options [Boolean] :background
  #   Specifies whether to run the editor as a background or foreground
  #   process.
  #
  # @option options [Proc] :terminal
  #   A lambda that generates the terminal command to run a given
  #   editor command within.
  #
  # @option options [String] :editor
  #   The command to spawn a new editor.
  #
  # @option options [Integer] :pause
  #   The number of seconds to pause in-between checking if any of the
  #   sketches were modified.
  #
  # @return [nil]
  #
  # @example
  #   Sketches.config :editor => 'gvim', :pause => 2
  #
  # @example Configure Sketches with a custom terminal command.
  #   Sketches.config :editor => 'vim',
  #                   :background => true,
  #                   :terminal => lambda { |cmd|
  #                     "xterm -fg gray -bg black -e #{cmd.dump}"
  #                   }
  #
  def Sketches.config(options={})
    if options[:tmpdir]
      Config.tmpdir = options[:tmpdir]
    end

    if options[:background]
      Config.background = options[:background]
    end

    if options[:terminal]
      Config.terminal = options[:terminal]
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
  # @return [Cache]
  #   The cache of sketches.
  #
  def Sketches.cache
    unless @@sketches_cache
      @@sketches_cache = Cache.new
    end

    return @@sketches_cache
  end

  #
  # Creates or edits a sketch.
  #
  # @param [Integer, Symbol, nil] id_or_name
  #   The optional sketch ID or name to edit.
  #
  # @return [nil]
  #
  # @example Create/Edit sketch #2
  #   Sketches.sketch 2
  #
  # @example Create/Edit the 'foo' sketch
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
  # Loads a new sketch from a given path.
  #
  # @param [String] path
  #   The path of an old sketch.
  #
  # @return [nil]
  #
  # @example
  #   Sketches.from 'path/to/foo.rb'
  #
  def Sketches.from(path)
    Sketches.cache.synchronize do
      sketch = Sketches.cache.reuse_sketch(path)

      sketch.synchronize { sketch.edit }
    end
  end

  #
  # Names a sketch.
  #
  # @param [Integer] id
  #   The sketch ID to name.
  #
  # @param [Symbol] name
  #   The name to assign to the sketch.
  #
  # @return [nil]
  #
  # @example
  #   Sketches.name 2, :foo
  #
  def Sketches.name(id,name)
    Sketches.cache.synchronize do
      Sketches.cache.name_sketch(id,name)
    end
  end

  #
  # Saves a sketch.
  #
  # @param [Integer, Symbol] id_or_name
  #   The sketch ID or name to save.
  #
  # @param [String] path
  #   The path to save the sketch to.
  #
  # @example
  #   Sketches.save 2, 'path/to/example.rb'
  #
  # @example
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
  # @return [nil]
  #
  def Sketches.print
    Sketches.cache.synchronize { puts Sketches.cache }
  end
end
