### SETUP

Download the LATEST version of SuperCollider from:
https://supercollider.github.io/download

Download sc3-plugins from:
https://supercollider.github.io/sc3-plugins/
- click the button in section "Releases" and then choose your OS
- make sure that the plugins' version matches your SuperCollider
- go back and follow the instructions in section "Installation"

### CUSTOM CLASSES

Put all *.sc files in one of the following directories:
- Platform.userExtensionDir
- Platform.systemExtensionDir
(see section "SETUP" for more details)

You may want to experiment with the Classes, but note that the Class
code cannot be simply "run" - every change must be saved. Also, you will
need to "Recompile Class Library" (available under the "Language" menu)
or restart the SuperCollider IDE.
Note that if the file contains errors, then the SuperCollider server will
refuse to start, therefore additional care is required.
If the file gets messed up beyond repair, simply delete it (or move to
another directory) and download the original version again.
