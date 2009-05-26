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

require 'sketches/sketches'

module Kernel
  #
  # Edits the sketch with the specified _id_or_name_. If no sketch exists
  # with the specified _id_or_name_, one will be created.
  #
  #   sketch 2
  #
  #   sketch :foo
  #
  def sketch(id_or_name=nil)
    Sketches.sketch(id_or_name)
  end

  #
  # Creates a new sketch using the specified _path_.
  #
  #   sketch_from 'path/to/foo.rb'
  #
  def sketch_from(path)
    Sketches.from(path)
  end

  #
  # Names the sketch with the specified _id_ with the specified _name_.
  #
  #   name_sketch 2, :foo
  #
  def name_sketch(id,name)
    Sketches.name(id,name)
  end

  #
  # Saves the sketch with the specified _id_or_name_ to the specified
  # _path_.
  #
  #   save_sketch :foo, 'path/to/foo.rb'
  #
  def save_sketch(id_or_name,path)
    Sketches.save(id_or_name,path)
  end

  #
  # Print out all of the sketches.
  #
  def sketches
    Sketches.print
  end
end
