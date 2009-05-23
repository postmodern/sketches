module Sketches
  module Config
    # Directory to store sketches in
    DIR = File.expand_path(File.join(ENV['HOME'],'.sketches'))

    # Default editor to use
    EDITOR = ENV['EDITOR']
  end
end
