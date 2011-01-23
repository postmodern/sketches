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

require 'tmpdir'

module Sketches
  module Config
    # Directory to store temporary sketches in
    TMPDIR = Dir.tmpdir

    # Default editor to use
    EDITOR = ENV['EDITOR']

    # Default pause between checking if sketches were modified
    PAUSE = 3

    @@sketches_tmpdir = TMPDIR
    @@sketches_background = false
    @@sketches_eval_after_editor_quit = false
    @@sketches_terminal = nil
    @@sketches_editor = EDITOR
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
      @@sketches_tmpdir = File.expand_path(directory)
    end

    #
    # Returns +true+ if the editor shall be ran as a background or a
    # foreground process, returns +false+ otherwise.
    #
    #   Config.background
    #   # => false
    #
    def Config.background
      @@sketches_background
    end

    #
    # Sets the background mode to the specified _mode_.
    #
    #   Config.background = true
    #
    def Config.background=(mode)
      @@sketches_background = mode
    end

    #
    # Returns +true+ if the sketch is eval'd immediatly
    # on editor quit (only if background = false)
    #
    #   Config.eval_after_editor_quit
    #   # => false
    #
    def Config.eval_after_editor_quit
      @@sketches_eval_after_editor_quit
    end

    #
    # When background is false, can eval immediately after editor quits.
    #
    #   Config.eval_after_editor_quit = true
    #
    def Config.eval_after_editor_quit=(mode)
      @@sketches_eval_after_editor_quit = mode
    end

    #
    # Returns the terminal to optionally run the editor within.
    #
    #   Config.terminal
    #   # => "xterm"
    #
    def Config.terminal
      @@sketches_terminal
    end

    #
    # Sets the terminal to optionally run the editor within to the
    # specified _new_term_. _new_term_ may either be a String or a
    # Proc.
    #
    #   Config.terminal = 'gnome-terminal'
    #
    #   Config.terminal = lambda { |cmd|
    #     "xterm -fg gray -bg black -e #{cmd.dump} &"
    #   }
    #
    def Config.terminal=(new_term)
      @@sketches_terminal = new_term
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
