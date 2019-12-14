
// KEYBOARD SHORTCUTS

// may vary between OS; 'C' denotes the 'Ctrl' (Linux/Windows) or 'Cmd' key (macOS), 'S' stands for 'Shift'

// basic stuff
// C-b        - boot server
// C-.        - stop everything
// C-Enter    - run code (current block/line/selection)
// S-Enter    - run code (current line/selection)
// C-d        - show documentation (select function/class)

// advanced users
// C-m        - show server meter
// C-S-m      - show scope
// C-A-m      - show freqscope
// C-A-t      - show node tree
// C-S-p      - clear post window
// C-S-Space  - show arguments with default values (cursor must be placed between parentheses)

// experts only! :)
// C-S-l - recompile class library


// BEFORE WE START:
//   currently you're looking at the CODE EDITOR
//       this is where we write and run the code
//   in the top right corner there should be a HELP BROWSER window
//       this is where the documentation will be shown
//   below there is a POST WINDOW
//       always read everything that appears in the Post Window, even if you don't fully understand it at the time!
//   lines starting with '//' are COMMENTS
//       SuperCollider will ignore them while running the code
you don't have to use // as long as you won't run this line of code (also, some words will get "randomly" colored by SuperCollider - can you guess why?)
//   every line of code should end with ';'


// EXERCISE 1
// run the following line (put the cursor anywhere in the line, then press C-Enter or S-Enter)
{ SinOsc.ar(mul: 0.1, add: 0.0); }.play;
// check the post window - there should be a one-line message denoting that a new Synth was created
// can you hear the sound? if not, then it means we forgot to boot the server (C-b)
// now run the code again (this time try the other shortcut)
// stop the sound (C-.)
// What was that sound, you wonder? Put the cursor on the 'SinOsc' part of the line and open the documentation (C-d). Read the description.


// EXERCISE 2
// the following four lines are a block of code - note the matching parentheses in the first and the last line
(
{ SinOsc.ar(mul: 0.1, add: 0.0); }.play;
{ VarSaw.ar(mul: 0.05, add: 0.0); }.play;
)
// use C-Enter to play the whole block (put the cursor anywhere in the block)
// stop the sound
// use S-Enter to play only one line
// read the documentation of VarSaw


// EXERCISE 3
// open the server meter (C-m), scope (C-S-m), and freqscope (C-A-m) windows
// repeat the last two exercises and try to understand what's going on


// EXERCISE 4
// open the node tree window (C-A-t) - here you will see a list of all currently running synths
// clear the post window (C-S-p)
// run the above synths one by one, notice how they appear on the list (check the messages in the post window - the numbers should match)


// EXERCISE 5
// let's return to the first example
{ SinOsc.ar(mul: 0.1, add: 0.0); }.play;
// our goal is to change the frequency of the generated sound
// put the cursor anywhere between the parentheses and show the list of arguments (C-S-Space)
// can you guess which argument is responsible for the frequency?
// currently the default value is used, but you can modify it - see how the 'mul' argument is set to 0.1 instead of 1.0
// try to change the frequency to 220 Hz and run the Synth; if nothing can be heard, inspect the Post window for error messages and check the documentation for more examples


// Try to spend some time in the Help browser window and, especially, check out the Home page.
// The 'Getting started' section contains one of the best introductory tutorials you'll ever find.
// Don't worry if there's too much material, as you don't have to read everything now, but make a good habit of checking the documentation every time you encounter a new concept in the SuperCollider.
// Also, it might be beneficial to try to solve some practical exercises in the first place.
// When you feel comfortable enough, you should return to the documentation and read some advanced guides thoroughly - the SuperCollider is a powerful tool and you'll eventually need to understand its design to make a good use of it.