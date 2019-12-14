
// Start the server.

// Also, it is a good time to recall what happens if you add two audio signals, or multiply a signal by a constant.

// PROXYSPACE

// In this part we will use a ProxyMixer to control Synths.
// The available GUI is pretty convenient and will allow us to play with Synths' parameters.
// You should also open the server scope and the node tree windows - check them out regularly to see what's going on.
// Note that if you're using laptop speakers, then low-frequency oscilators can be inaudible. In that case, use headphones, but remember to turn the volume down, as the SuperCollider tends to be loud!

// SYNTAX

p = ProxySpace(); // this is an instance of ProxySpace, it will hold all our Synths
p.gui;            // opens the mixer - for now it's empty
p.clear;          // you can use this command later to remove all displayed Synths

// To add a new synth you must choose a name (symbol) and write a definition (function).
// Then run: p[\chosen_name] = { here_goes_Synth_definition };
// Remember the bracket notation, as it is quite common.

p[\example1] = { SinOsc.ar(); };

// EXERCISE 1
// Use the mixer to start/stop the \example1 Synth. Also, click the "ed" button and see what happens.


// The SinOsc class generates a simple sine wave. Method 'ar' (audio rate) tells the class to create a signal with high sample rate. Also, the method accepts some arguments that will affect the sound you hear.
// Always remember to use the 'ar' method!
// Do not confuse SinOsc with the Synth - the first one is a so-called UGen, which is a building block for Synths, whereas the second is defined by the whole function. In a moment you'll create more complicated Synths, which combine several UGens.

// EXERCISE 2
// Open the SinOsc documentation. Write a Synth with twice the default frequency. Set the signal amplitude to 0.5 (check the 'mul' parameter). Play with the two Synths using the mixer window.

p[\exercise2] = ...


// Recall that functions return only the last statement. Similarly, the Synth plays only the last UGen in its definition.

(
p[\example2] = {
	SinOsc.ar(freq: 880.0); // this part will not be heard
	SinOsc.ar(freq: 220.0); // this is the last UGen
};
)

// To mix a list of UGens you may use the Mix UGen (check the documentation), but here it's easier to simply add the two signals:

(
p[\example3] = {
	var sin1 = SinOsc.ar(freq: 880.0);
	var sin2 = SinOsc.ar(freq: 220.0);
	sin1 + sin2; // this is the last UGen, but it uses the two previous, so both of them will be heard
};
)

// EXERCISE 3
// Create a Synth that plays a C major chord using three combined sine waves. Make two variants - the first one should use the '+' operator to add signals, and the second should use Mix UGen (you'll need to create an Array of SinOsc UGens - see the examples in documentation if necessary).
// Then check if they sound exactly the same.
// If you don't remember the frequencies, but remember numerical values of the notes (here: 48, 52, 55), then you may use the 'midicps' method:

48.midicps; // this is approx. 130.8

// and you can simply write SinOsc.ar(freq: 48.midicps)

(
p[\exercise3_1] = {
	// variant: +
	// ...
};
p[\exercise3_2] = {
	// variant: Mix
	// ...
};
)


// You can modify the Synth definition as it's playing.

// EXERCISE 4
// Stop all Synths, then choose a single one and play it.
// Now modify its code - e.g. change the frequency - and run the code line/block.
// You should hear the new frequency.


// There's a simpler way of changing the parameters - you need to declare them as arguments of the Synth definition

p[\example4] = { arg freq; SinOsc.ar(freq: freq); };

// Play the Synth and push the 'ed' button to access the new slider.
// Observe that the value range is automatically set to 20 - 20000, and the scale is logarithmic.
// Somehow the SuperCollider knows that this argument represents sound frequency!
// So let's try something more complicated:

(
p[\example5] = { arg freq1, freq2;
	var sin1 = SinOsc.ar(freq: freq1);
	var sin2 = SinOsc.ar(freq: freq2);
	sin1 + sin2;
};
)

// and now it's broken... The frequency range is -2 - 2 (negative frequencies are actually ok, the sound will simply go "backwards"), and you, probably, cannot hear anything.
// It turns out that the SuperCollider keeps a list of known argument NAMES with details about how to display sliders to control them.
// Check the Spec documentation to see the full list:
help(Spec); // section "Examples"

// This is why the \freq argument was recognised, but not \freq1 nor \freq2

\freq.asSpec; // a ControlSpec(20, 20000, 'exp', 0, 440, " Hz")

// Let's define new Specs:
(
Spec.add(\freq1, ControlSpec(minval: 20.0, maxval: 20000.0, warp: 'exp', step: 0.0, default: 440.0, units: " Hz"));
Spec.add(\freq2, ControlSpec(minval: 20.0, maxval: 20000.0, warp: 'exp', step: 0.0, default: 440.0, units: " Hz"));
)

// now close and reopen the mixer window to apply the new settings

// EXERCISE 5
// Modify 'example5' so that the arguments are notes (integers), not frequencies.
// Make sure that only integers can be set using the slider.
// Check the ControlSpec arguments in the documentation (all but 'grid' are described there).
// Hint: Use argument "step".
// Hint2: Change the argument "warp" from 'exp' to ...? (figure it out!)
// In the Synth definition use the 'midicps' method.
// (of course note values don't have to be integers, i.e. 440.5.midicps will also work, but this constraint makes the exercise more interesting)

(
var spec = ...
Spec.add(\note1, spec);
Spec.add(\note2, spec);
p[\exercise5] = { arg note1, note2;
	...
};
)


// CHANNELS
// You've probably noticed that only the left speaker seems to be working.
// This is because if the Synth definition returns only a single UGen, it will be played on the first channel.
// If you want to use multiple channels, you must return an Array of UGens.
// Compare
p[\example1] = { SinOsc.ar(); };
// with
p[\example6] = { [ SinOsc.ar(), SinOsc.ar() ]; };
p[\example6] = { SinOsc.ar() ! 2; }; // "! 2" means "duplicate twice, put into an Array"

// Different channels may play different UGens
p[\example7] = { [ SinOsc.ar(freq: 440, mul: 0.5), SinOsc.ar(freq: 300, mul: 0.2) ]; };

// MULTICHANNEL EXPANSION
// If you pass an Array instead of a number as a value of Ugen's argument, then the SuperCollider will create an Array of UGens for you - this is called the "multichannel expansion"
SinOsc.ar(freq: [110, 220, 333, 437], phase: 0.3); // an Array of four different SinOscs, each has different frequency, all have same phase


// EXERCISE 6
// Repeat Exercise 3, but now make sure that the same sound is played from both speakers.
// The tricky part is that you are allowed to write "SinOsc" ONLY ONCE, and the Synth definition must have exactly ONE LINE
// Which approach is correct here - using the '+' operator, or the Mix UGen?
p[\exercise6] = { ... ; };


// Spend some time reading the documentation about the new concepts you've learned.
