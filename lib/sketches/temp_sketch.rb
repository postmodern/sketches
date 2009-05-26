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
    def initialize
      super(BASENAME,Config.tmpdir)
    end

    private

    def make_tmpname(basename,n)
      prefix, suffix = basename, EXT

      t = Time.now.strftime("%Y%m%d")
      return "#{prefix}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}-#{n}#{suffix}"
    end
  end
end
