require 'sketches/sketches'

module Kernel
  def sketch(id_or_name=nil)
    Sketchs.sketch(id_or_name)
  end

  def name_sketch(id,name)
    Sketches.name(id,name)
  end
end
