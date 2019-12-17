
// An Env instance holds the definition of an envelope. It is NOT a UGen! (hence the lack of ".kr" method)
e = Env.perc(attackTime: 0.01, releaseTime: 1.0, level: 2.0, curve: -4.0);
// You can plot the function:
e.plot;
// and also quickly test the envelope:
e.test;
// ".perc" creates an envelope with a percussive shape.
// See Env documentation, sections "Standard Shape Envelope Creation Methods" and "Sustained Envelope Creation Methods" for other possible shapes.

// EXERCISE 1
// Plot the envelope for several different values of every argument.
// Especially, try to understand the 'curve' argument (what happens for positive values?).
Env.perc(attackTime: 0.01, releaseTime: 1.0, level: 2.0, curve: -4.0).plot;


// An EnvGen IS a UGen that generates signal according to the passed envelope, but it comes with some additional functionalities.
(
SynthDef(
	name: \sinperc,
	ugenGraphFunc: { arg freq=440, amp=1.0, gate=1.0;
		var s = SinOsc.ar(freq: freq, mul: amp);
		var env = Env.perc(attackTime: 0.01, releaseTime: 1.0, level: 2.0, curve: -4.0);
		var envgen = EnvGen.kr(env, gate: gate, doneAction: Done.freeSelf);
		s = s * envgen; // modulate amplitude with the envelope
		Out.ar(0, s ! 2);
	}
).add;
)
// Open the Node Tree window, and then try the following line of code:
Synth(\sinperc);
// The Synth disappears on its own after it finished playing. This is due to the EnvGen's argument called doneAction. It specifies what to do with the WHOLE SYNTH after the EnvGen UGen finishes playing.


// EXERCISE 2
// Check the documentation of Done, section "Actions".
// Then modify the following code so that the Synth does not dissapear from the Node Tree after it finishes playing.
// Change only one argument.
(
SynthDef(
	name: \ex2,
	ugenGraphFunc: { arg freq=440, amp=1.0, gate=1.0;
		var s = SinOsc.ar(freq: freq, mul: amp);
		var env = Env.perc(attackTime: 0.01, releaseTime: 1.0, level: 2.0, curve: -4.0);
		var envgen = EnvGen.kr(env, gate: gate, doneAction: Done.freeSelf);
		s = s * envgen;
		Out.ar(0, s ! 2);
	}
).add;
)
Synth(\ex2); // run this several times, see if the Synths disappear from the Node Tree
// Finally, remove them using the stop-all shortcut (C-.)

// The 'gate' argument behaves in the following way:
// - when it's set to a positive value, it starts the Synth,
// - when set to zero, it triggers the release
// (check the documentation for negative values of gate)
// Since the default value of 'gate' is set to 1.0, the Synth starts immediately.
// Env.perc does not wait for 'gate' to be set to zero and releases automatically, but later you'll see an example of envelope with sustain - be patient, and don't forget about this functionality.

// EXERCISE 3
// Create an instance of \sinperc Synth, but set the initial value of gate to zero.
a = Synth(...);
// Check the Node Tree - the Synth should sit on the list silently.
// Now set the gate to a positive number (it doesn't have to be exactly one).
a.??? ;
// Observe the Synth disappearing after being played.


// EXERCISE 4
// Here are some white keys for you, play a tune!
Synth(\sinperc, [\freq, 60.midicps]); // C4
Synth(\sinperc, [\freq, 62.midicps]); // D4
Synth(\sinperc, [\freq, 64.midicps]); // E4
Synth(\sinperc, [\freq, 65.midicps]); // F4
Synth(\sinperc, [\freq, 67.midicps]); // G4
Synth(\sinperc, [\freq, 69.midicps]); // A4
Synth(\sinperc, [\freq, 71.midicps]); // B4
Synth(\sinperc, [\freq, 72.midicps]); // C5


// If you use multiple EnvGens, then the Synth will be stopped as soon as any of them finishes.
(
SynthDef(
	name: \sinperc2,
	ugenGraphFunc: { arg freq=440, amp=1.0, gate=1.0;
		var s = SinOsc.ar(freq: freq, mul: amp);
		var env = Env.perc(attackTime: 0.01, releaseTime: 1.0, level: 2.0, curve: -4.0);
		var envgen = EnvGen.kr(env, gate: gate, doneAction: Done.freeSelf);
		Out.ar(0, s*envgen ! 2);
		EnvGen.kr(Env.perc(0.0, 0.2), gate: gate, doneAction: Done.freeSelf); // this ends after only 0.2 seconds
	}
).add;
)
Synth(\sinperc2);
// The sound ends abruptly after 0.2 seconds due to the EnvGen present in the last line of Synth definition. Note that this EnvGen is never used to modify the actual sound, nevertheless it is a part of the Synth, so it will stop everything else!

// You can also use the envelope to modify other parameters of the sound, not only the amplitude.

(
SynthDef(
	name: \chirp,
	ugenGraphFunc: { arg freq=440, amp=0.3, gate=1.0;
		var env = Env.perc(attackTime: 0.01, releaseTime: 1.0, level: 2.0, curve: -4.0);
		var envgen = EnvGen.kr(env, gate: gate, doneAction: Done.freeSelf);
		var s = SinOsc.ar(freq: freq*envgen, mul: amp);
		Out.ar(0, s ! 2);
	}
).add;
)
Synth(\chirp); // run this multiple times

// EXERCISE 5
// When the \chirp Synth ends playing, you'll hear an irritating click.
// Explain the reason it's there. Hint: Open the scope window.
// Can you get rid of it by changing the Synth definition?


// And now it's time for the promised envelope with sustain.
(
SynthDef(
	name: \sinasr,
	ugenGraphFunc: { arg freq=440, amp=1.0, gate=1.0;
		var s = SinOsc.ar(freq: freq, mul: amp);
		var env = Env.asr(attackTime: 0.01, sustainLevel: 1.0, releaseTime: 1.0, curve: -4.0);
		var envgen = EnvGen.kr(env, gate: gate, doneAction: Done.freeSelf);
		s = s * envgen;
		Out.ar(0, s ! 2);
	}
).add;
)
// Run the following line...
Synth(\sinasr);
// ... and now you cannot stop it without the "stop all" command, which should be used only as a last resort

// A better way - use the 'gate' argument:
a = Synth(\sinasr); // 'gate' is set to 1.0 by default, Synth starts automatically
a.set(\gate, 0);

// EXERCISE 6
// Run the two lines above while looking at the scope and the Node.
// Now run these:
a = Synth(\sinasr);
a.free;
// Explain the difference.


// POLYPHONY

// If the Synth releases automatically, then polyphony is quite easy:
(
var amp = 0.1;
Synth(\sinperc, [\freq, 60.midicps, \amp, amp]); // C4
Synth(\sinperc, [\freq, 62.midicps, \amp, amp]); // D4
Synth(\sinperc, [\freq, 64.midicps, \amp, amp]); // E4
Synth(\sinperc, [\freq, 65.midicps, \amp, amp]); // F4
Synth(\sinperc, [\freq, 67.midicps, \amp, amp]); // G4
Synth(\sinperc, [\freq, 69.midicps, \amp, amp]); // A4
Synth(\sinperc, [\freq, 71.midicps, \amp, amp]); // B4
Synth(\sinperc, [\freq, 72.midicps, \amp, amp]); // C5
)
// but in case of Env.asr you need to store all the playing Synths in variables, so you'll be able to turn them off.
// The most basic approach is to create an empty Array of size 128 - one slot per possible midi note, - and then every time you create a new Synth, you'll have some place to keep it until you decide to release.

(
v = nil ! 128; // an empty Array of size 128
~noteOn = { arg note;
	var synth = Synth(\sinasr, [\freq, note.midicps]); // start the Synth
	v[note] = synth; // put it inside the global array 'v', 'note' also specifies the slot number
};
~noteOff = { arg note;
	v[note].set(\gate, 0); // release the Synth
	v[note] = nil;         // empty the array - this does NOT destroy the Synth (check the Node Tree if you don't believe me), but you cannot talk to it anymore (which is fine in this case, right?)
};
)

// Now try to run:
~noteOn.(60);
~noteOff.(60);

// EXERCISE 7
~noteOn.(60);  // Run this at least twice.
~noteOff.(60); // Run this as many times as you want. When you give up, stop all sound (C-.)
// Can you explain why you weren't able to release the Synth?
// Now change the ~noteOn definition. Run the following code:
(
// safe variant
~noteOn = { arg note;
	var synth = Synth(\sinasr, [\freq, note.midicps]);
	if( v[note].isNil.not ) { v[note].set(\gate, 0); }; // a suspicious new line of code...
	v[note] = synth;
};
)
~noteOn.(60);  // Run this as many times as you want.
~noteOff.(60); // Run this only once.
// Can you explain why this variant works better?


// EXERCISE 8
// Here are some white keys with sustain, play your favourite chords!

~noteOn.(60);  // C4
~noteOff.(60); // C4
~noteOn.(62);  // D4
~noteOff.(62); // D4
~noteOn.(64);  // E4
~noteOff.(64); // E4
~noteOn.(65);  // F4
~noteOff.(65); // F4
~noteOn.(67);  // G4
~noteOff.(67); // G4
~noteOn.(69);  // A4
~noteOff.(69); // A4
~noteOn.(71);  // B4
~noteOff.(71); // B4
~noteOn.(72);  // C5
~noteOff.(72); // C5

// (Optionally: run the code block below to replace sine waves with \bow.)
(
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
~noteOn = { arg note;
	var synth = Synth(\bow, [\freq, note.midicps]);
	if( v[note].isNil.not ) { v[note].set(\gate, 0); };
	v[note] = synth;
};
)