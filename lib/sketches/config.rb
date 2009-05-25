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

module Sketches
  module Config
    # Directory to store sketches in
    DIR = File.expand_path(File.join(ENV['HOME'],'.sketches'))

    # Default editor to use
    EDITOR = ENV['EDITOR']

    # Default pause between checking if sketches were modified
    PAUSE = 3

    def Config.editor
      @@sketches_editor || EDITOR
    end

    def Config.editor=(new_editor)
      @@sketches_editor = new_editor
    end

    def Config.pause
      @@sketches_pause || PAUSE
    end

    def Config.pause=(new_pause)
      @@sketches_pause = new_pause
    end
  end
end
