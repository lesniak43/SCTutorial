
// This is a short introduction to parsing MIDI messages in SuperCollider.
// If you want to know more, read the article "Using MIDI" in the documentation.
// Also, it is assumed that you have a basic understanding of how MIDI works.

// To enable MIDI in your code:
// 1) Connect the MIDI device to the computer.
// 2) Initialize:
MIDIClient.init;
// 3) Tell SuperCollider to listen to all incoming MIDI messages:
MIDIIn.connectAll;

// Now you need to find out what kinds of messages your device sends.
// The following line will enable tracing - every received message will appear in the post window
MIDIFunc.trace;
// Later you may want to disable tracing:
MIDIFunc.trace(false);

// EXAMPLE OUTPUT
//
// MIDI Message Received:
// 	type: noteOn
// 	src: 917504
// 	chan: 0
// 	num: 16
// 	val: 100
//
// MIDI Message Received:
// 	type: noteOff
// 	src: 917504
// 	chan: 0
// 	num: 16
// 	val: 0
//
// MIDI Message Received:
// 	type: control
// 	src: 917504
// 	chan: 0
// 	num: 2
// 	val: 81

// EXERCISE 1
// Make a list of all MIDI messages your device can send.
// If it's a keyboard, then take a closer look at noteOn and noteOff messages - e.g. check the channel number. "num" should correspond to the note number by default.
// You may have some knobs/sliders/buttons sending control messages - check "chan" and "num". Check the range of "val" - most devices will have full range 0 - 127 for knobs and sliders, and two discrete values 0/127 for button off/on respectively.


// The next step is to instruct SuperCollider to take action when a MIDI message is received.
// You need to create a function that takes four arguments: val, num, chan, src.
(
f = { arg val, num, chan, src;
	"Our custom function 'f' is called".postln;
	"val:  ".post; val.postln;
	"num:  ".post; num.postln;
	"chan: ".post; chan.postln;
	// "src:  ".post; src.postln; // you don't need to use all the arguments
};
)
// Now choose a message type you want to respond to (let's start with noteOn), and bind the function:
MIDIdef.noteOn(key: \examplefunction, func: f);

// EXERCISE 2
// Disable message tracing, and use your device to send some noteOn messages. Check the post window.
// Example output (after pressing C4):
//
// Our custom function 'f' is called
// val:  100
// num:  60
// chan: 0


// Check the MIDIdef documentation for other methods (e.g. ".cc" for control messages, ".bend" for pitch bend)

// IMPORTANT:
// Functions that respond to one of the following message types:
// - touch,
// - program change,
// - bend,
// must have arguments 'val', 'chan', and 'src' - without 'num'.
// Also, when you use C-. (stop all), all function bindings are removed by default. If this is a problem, you can:
// - stop using C-. (recommended)
// - read the documentation and find a workaround (I won't help you here, because overusing C-. is a bad habit)

// The 'key' argument may be any symbol, but reusing it will overwrite the previously set function:
(
g = { arg val, num, chan, src;
	"Function 'g'".postln;
	"src:  ".post; src.postln;
};
MIDIdef.noteOn(key: \examplefunction, func: g);
)

// EXERCISE 3
// Repeat Exercise 2.
// Example output (after pressing C4):
//
// Function 'g'
// src:  917504 (this line may be different for you)


// If you want to assign both functions to noteOn messages, just think about another name for the second one.
// You can also assign a single function multiple times.
(
MIDIdef.noteOn(key: \examplefunction, func: f);
MIDIdef.noteOn(key: \fagain, func: f);
MIDIdef.noteOn(key: \somefunctiong, func: g);
)

// EXERCISE 4
// Repeat Exercise 2.
// Example output (after pressing C4 ONCE):
//
// Our custom function 'f' is called
// val:  100
// num:  60
// chan: 0
// Our custom function 'f' is called
// val:  100
// num:  60
// chan: 0
// Function 'g'
// src:  1310720


// You can remove specific bindings with:
(
MIDIdef(\examplefunction).free;
MIDIdef(\fagain).free;
MIDIdef(\somefunctiong).free;
)
// or all at once:
MIDIdef.freeAll;

// Methods such as ".noteOn" have additional arguments that allow you to filter incoming messages.
(
a = { arg val, num, chan, src;
	"I respond only to C4, value equal to: ".post; val.postln;
};
MIDIdef.noteOn(key: \a, func: a, noteNum: 60);
// MIDIdef.cc(key: \a, func: a, ccNum: 1); // only knob/slider sending control messages with number 1
b = { arg val, num, chan, src;
	"I respond only to notes >=80".postln;
	"num: ".post; num.postln;
	"val: ".post; val.postln;
};
MIDIdef.noteOn(key: \b, func: b, noteNum: (80..127));
)

// EXERCISE 5
// Repeat Exercise 2. You should get the idea by now.


// There are four methods that come in handy if you want to translate one range of numbers into another: linlin, linexp, explin, expexp.
// All of them have arguments:
//   (inMin, inMax, outMin, outMax, clip: 'minmax')
// For example, knobs/sliders may send messages with values from 0 to 127. If you want to control the signal amplitude (ranging from 0 to 1), you might use val.linlin(0, 127, 0, 1)
(
var val = 25; // replace with different values, run, observe post window
val.linlin(0, 127, 0, 1).postln;
)
// This may sound more natural
(
var val = 64; // replace with different values, run, observe post window
val.linexp(0, 127, 0.001, 1).postln;
)
// Recall that the relation between note numbers and frequencies is exponential:
(
var note = 70; // replace with different values, run, observe post window
"midicps: ".post; note.midicps.postln;
"linexp:  ".post; note.linexp(0, 127, 0.midicps, 127.midicps).postln;
)


// EXERCISE 6
// It is assumed that you have a MIDI device with keyboard and at least two knobs.
// (If not, use a virtual XY controller with keyboard.)
// You'll create a polyphonic bow synthesizer.
// Run the following code:
(
MIDIdef.freeAll; // reset all bindings

v = nil ! 128; // Array for storing Synths

SynthDef(
	name: \bow,
	ugenGraphFunc: { arg freq=440, amp=0.01, force=0.1, gate=1, pos=0.07, c1=0.25, c3=31;
		var vib = Gendy1.kr(1,1,1,1,0.1,4,mul:0.003,add:1);
		var son = DWGBowed.ar(freq*vib,amp,force,1,pos,0.1,c1,c3);
		var env = Env.asr(attackTime: 0.01, sustainLevel: 1.0, releaseTime: 1.0, curve: -4.0);
		var envgen = EnvGen.kr(env, gate: gate, doneAction: Done.freeSelf);
		son = DWGSoundBoard.ar(son);
		son = BPF.ar(son,118,1)+son;
		son = BPF.ar(son,430,1)+son;
		son = BPF.ar(son,490,1)+son;
		son = LPF.ar(son,6000);
		Out.ar(0, son*envgen ! 2);
	}
).add;

x = Bus.control();
y = Bus.control();
)
// Fill in the following block of code according to the instructions.
(
// Set values of Buses x and y to 0.25 and 31 respectively.
... ;
... ;
MIDIdef.noteOn(
	key: \noteon,
	func: { ... ; // define arguments
		var synth = ... ; // create a \bow Synth, set frequency using note number (appropriately converted), set amplitude using message value (convert value to range 0.0001 - 0.05)
		... ; // map the Buses x and y to \c1 and \c3 respectively
		... ; // check if the Array slot is empty, and if not, then release the old Synth
		... ; // insert 'synth' into the array
	}
);
MIDIdef.noteOff(
	key: \noteoff,
	func: { ... ; // define arguments
		... ; // release the Synth
		... ; // set the Array slot to nil
	}
);
MIDIdef.cc(
	key: \knobX,
	func: { ... ; // define arguments
		... ; // set the x Bus using message value (convert value to range 0.001 - 100)
	},
	... // make sure that this function responds only to messages generated by knob X
);
MIDIdef.cc(
	key: \knobY,
	func: { ... ; // define arguments
		... ; // set the y Bus using message value (convert value to range 0.1 - 10000)
	},
	... , // make sure that this function responds only to messages generated by knob Y
);
)
