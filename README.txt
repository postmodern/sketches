= Sketches

* http://github.com/postmodern/sketches/
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

Sketches allows you to create and edit Ruby code from the comfort of your
editor, while having it safely reloaded in an IRB session whenever your
code changes.

== FEATURES:

* Spawn your choice of editor from IRB.
* Automatically reload your code as it changes.

== INSTALL:

  $ sudo gem install sketches

Then require sketches in your <tt>.irbrc</tt> file:

  require 'sketches'

Sketches can also be configured to use a custom editor command:

  Sketches.config :editor => 'gvim'

  Config.editor = lambda { |path|
    "xterm -fg gray -bg black -e vim #{path} &"
  }

== EXAMPLES:

* Open a new sketch:

  sketch

* Open a new named sketch:

  sketch :foo

* Open a sketch from an existing file:

  sketch_from 'path/to/bar.rb'

* Open an existing sketch:

  sketch 2

  sketch :foo

* List all sketches:

  sketches

* Name a sketch:

  name_sketch 2, :foo

* Save a sketch to an alternant location:

  save_sketch :foo, 'path/to/foo.rb'

== LICENSE:

Sketches - A Ruby library for live programming.

Copyright (c) 2009 Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
