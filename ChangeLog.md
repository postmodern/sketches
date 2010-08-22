### 0.1.1 / 2009-12-12

* Added {Sketches::Config.terminal}.
* Added {Sketches::Config.terminal=}.
* Added {Sketches::Config.background}.
* Added {Sketches::Config.background=}.
* Allow the editor command to be ran in a new terminal.
* Allow running the editor command in the background.
* Allow sketch files to be evaled immediately after exiting the editor
  (thanks Jonathan Penn).
* Fixed a bug with TempSketch.open on JRuby (thanks Sergey Moshnikov).

### 0.1.0 / 2009-04-29

* Initial release:
  * Spawn an editor of your choosing from IRB.
  * Automatically reload your code when it changes.
  * Use a custom editor command.
  * Use a custom temp directory to store sketches in.

