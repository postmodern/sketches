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

  def Sketches.name(id,name)
    Sketches.cache.syncrhonize do
      Sketches.cache.name_sketch(id,name)
    end
  end
end
