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

module Sketches
  def Sketches.editor
    @@sketches_editor || Config::EDITOR
  end

  def Sketches.editor=(new_editor)
    @@sketches_editor = new_editor
  end

  def Sketches.start(&block)
    block.call(self) if block
  end

  @@sketches_cache = Cache.new

  def Sketches.cache
    @@sketches_cache
  end

  def Sketches.sketch(id_or_name)
    Sketches.cache.synchronize do
      sketch = Sketches.cache[id_or_name]
      sketch ||= Sketches.cache.new_sketch(id_or_name)

      sketch.synchronize { sketch.edit }
    end
  end

  def Sketches.from(path)
    Sketches.cache.syncrhonize do
      Sketches.cache.reuse_sketch(path)
    end
  end

  def Sketches.name(id,name)
    Sketches.cache.syncrhonize do
      Sketches.cache.name_sketch(id,name)
    end
  end
end
