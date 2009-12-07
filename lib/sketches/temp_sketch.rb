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

require 'tempfile'

module Sketches
  class TempSketch < Tempfile

    # Basename to use for temp sketches
    BASENAME = 'sketch'

    # Extension to use for temp sketches
    EXT = '.rb'

    #
    # Create a new TempSketch object.
    #
    def self.open_temp_sketch(&block)
      open(BASENAME, Config.tmpdir, &block)
    end

    private

    def make_tmpname(basename,n)
      prefix, suffix = basename, EXT

      t = Time.now.strftime("%Y%m%d")
      return "#{prefix}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}-#{n}#{suffix}"
    end
  end
end
