= Sketches

* http://sketches.rubyforge.org/
* http://github.com/postmodern/sketches/
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

Sketches allows you to create and edit Ruby code from the comfort of your
editor, while having it safely reloaded in IRB whenever changes to the
code are saved.

== FEATURES:

* Spawn an editor of your choosing from IRB.
* Automatically reload your code when it changes.
* Run the editor in the background.
* Run the editor in a new terminal.
* Use a custom editor command.
* Use a custom terminal command.
* Use a custom temp directory to store sketches in.

== PROBLEMS:

* Local variables cannot be loaded. Ruby defines local variables as local
  to the file which they were originally defined in.
* No support for Inotify or FSevent _yet_. It would be nice to attempt to
  use Inotify or FSevent bindings, if available, for efficient polling of
  sketch files.

== INSTALL:

  $ sudo gem install sketches

Then require sketches in your <tt>.irbrc</tt> file:

  require 'sketches'

Sketches can be configured to use a custom editor command:

  Sketches.config :editor => 'gvim'

Sketches can also be configured to run in a new terminal:

  Sketches.config :editor => 'vim',
                  :background => true,
                  :terminal => lambda { |cmd|
                    "xterm -fg gray -bg black -e #{cmd.dump}"
                  }

== EXAMPLES:

* Open a new sketch:

    sketch

* Open a new named sketch:

    sketch :foo

* Open a sketch from an existing file:

    sketch_from 'path/to/bar.rb'

* Reopen an existing sketch:

    sketch 2

    sketch :foo

* List all sketches:

    sketches

* Name a sketch:

    name_sketch 2, :foo

* Save a sketch to an alternant location:

    save_sketch :foo, 'path/to/foo.rb'

== LICENSE:

Sketches - A Ruby library for live programming and code reloading.

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
