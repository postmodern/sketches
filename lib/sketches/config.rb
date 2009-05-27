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

require 'tmpdir'

module Sketches
  module Config
    # Directory to store temporary sketches in
    TMPDIR = Dir.tmpdir

    # Default editor to use
    EDITOR = ENV['EDITOR']

    # Default pause between checking if sketches were modified
    PAUSE = 3

    @@sketches_editor = EDITOR
    @@sketches_tmpdir = TMPDIR
    @@sketches_pause = PAUSE

    #
    # Returns the directory to store temporary sketches in.
    #
    #   Config.tmpdir
    #   # => "/tmp"
    #
    def Config.tmpdir
      @@sketches_tmpdir
    end

    #
    # Sets the directory to store temporary sketches in to the specified
    # _directory_.
    #
    def Config.tmpdir=(directory)
      @@sketches_tmpdir = File.expand_path(dir)
    end

    #
    # Returns the current editor to use for editing sketches.
    #
    #   Config.editor
    #   # => 'pico'
    #
    def Config.editor
      @@sketches_editor
    end

    #
    # Use the specified _new_editor_ to edit sketches. _new_editor_ may
    # be either a String or a lambda which accepts the +path+ of the sketch
    # and returns the command to run.
    #
    #   Config.editor = 'gvim'
    #
    #   Config.editor = lambda { |path|
    #     "xterm -fg gray -bg black -e vim #{path} &"
    #   }
    #
    def Config.editor=(new_editor)
      @@sketches_editor = new_editor
    end

    #
    # Returns the current number of seconds to pause in between checking
    # if any sketches were modified.
    #
    #   Config.pause
    #   # => 3
    #
    def Config.pause
      @@sketches_pause
    end

    #
    # Use the specified number of _seconds_ to pause in between checking
    # if any sketches were modified.
    #
    #   Config.pause = 2
    #
    def Config.pause=(seconds)
      @@sketches_pause = seconds
    end
  end
end
