
// From now on you won't be using the ProxyMixer to control Synths. Instead, we will learn how to perform basic operations on Synths directly from code.

// SYNTHDEF
// Using SynthDef is the "proper" way of defining Synths

(
f = { arg freq=440, amp=0.1, force=1, gate=1, pos=0.07, c1=0.25, c3=31;
    var vib = Gendy1.kr(1,1,1,1,0.1,4,mul:0.003,add:1);
    var son = DWGBowed.ar(freq*vib,amp,force,gate,pos,0.1,c1,c3);
    son = DWGSoundBoard.ar(son);
    son = BPF.ar(son,118,1)+son;
    son = BPF.ar(son,430,1)+son;
    son = BPF.ar(son,490,1)+son;
    son = LPF.ar(son,6000);
	son ! 2;
};
)

// Recall that this function only defines a Synth.
// To actually play it we could write:
a = f.play; // now s contains a Synth
a.free;     // stop the Synth
// or you could add the function to a ProxySpace.
// But now we will write:

SynthDef(name: \bow, ugenGraphFunc: f).add;
// You can choose any name you like.
// Do not forget the '.add' method at the end - if you do, then you'll only create a SynthDef, but the definition will not be available for you in other parts of the code.
// Usually, there's no need to hold the definition in a separate variable:

(
SynthDef(
	name: \bow,
	ugenGraphFunc: { arg freq=440, amp=0.1, force=1, gate=1, pos=0.07, c1=0.25, c3=31;
		var vib = Gendy1.kr(1,1,1,1,0.1,4,mul:0.003,add:1);
		var son = DWGBowed.ar(freq*vib,amp,force,gate,pos,0.1,c1,c3);
		son = DWGSoundBoard.ar(son);
		son = BPF.ar(son,118,1)+son;
		son = BPF.ar(son,430,1)+son;
		son = BPF.ar(son,490,1)+son;
		son = LPF.ar(son,6000);
		Out.ar(0, [son, son]);      // this is something new!
	}
).add;
)

// We've replaced the last line with Out.ar(0, [son, son]).
// Out is a special UGen that defines where the signal will be directed.
// The first argument is the bus number. Bus 0 is the left speaker, bus 1 is the right one. Buses with higher numbers are inaudible (unless you have more speakers).
// The second argument is the UGen that you want to output. If an array is given, then Out will automatically assign each element to consequtive buses.

// Now, to create a playing Synth, use it's name:
a = Synth(\bow);
a.free; // stop

// EXERCISE 1
(
SynthDef(
	name: \ex1,
	ugenGraphFunc: {
		var left, right;
		left = LFSaw.ar(freq: 500, mul: 0.3);
		right = SinOsc.ar(freq: 2700, mul: 0.3);
		Out.ar(bus: 0, channelsArray: [left, right]);
	}
).add;
)
e = Synth(\ex1);
e.free;
// Remember that after every change in the Synth definition you need to stop the running Synht, run the code in the block, and then create the synth again!
// Replace bus with 1, then with 2.
// Replace channelsArray with 'left' (or 'right'), also change the bus back to 1, then to 0.
// In each case, what do you hear and where does the sound come from? Explain.


// BASIC CONTROL

// If a ugenGraphFunc has arguments, you can set them while creating a Synth:
a = Synth(\bow, [\freq, 110, \force, 5, \amp, 0.001]);
b = Synth(\bow, [\freq, 880, \force, 0.3, \amp, 0.1]);

// To change the values of Synth arguments while running, use the method '.set'
b.set(\freq, 440, \force, 1, \c1, 100, \c3, 10000); // you can also set the other arguments
a.set(\pos, 0.5, \force, 43, \amp, 0.05);
b.run(false); // pause
a.set(\freq, 55, \amp, 0.001);
b.run(true);  // unpause
a.free; b.free; // stop the noise... I mean music!


// ADVANCED CONTROL

// A control Bus can be used to manipulate Synth parameters. It holds a single number that is read by the Synth, and can be changed at will.

x = Bus.control();
x.set(220); // setting the bus value
x.get(); // check the value in post window

// To connect a Synth with a Bus use the '.map' method.

a = Synth(\bow);
a.map(\freq, x); // let's map the bus to the Synth frequency

// Now change the value of the Bus
x.set(880);

// The Bus value can be controlled with another Synth.
// You can try to run the code below, but don't worry if you don't understand what's exactly going on.
v = {Out.kr(x, SinOsc.kr(MouseX.kr(0, 20), add: 440, mul: MouseY.kr(0, 40)))}.play(addAction: \addToHead); // move your mouse
v.free; // stop changing the bus value
x.get(); // the value should be somewhere between 400 and 480, and the Synth is playing this frequency right now
a.free;


// EXERCISE 2
// You can control multiple Synths with a single control bus.
// Create three \bow Synths playing different frequencies, store them in variables 'a', 'b', and 'c' respectively.
// Choose some nice frequencies, for example notes 73, 77, and 80 (use '.midicps').
// Create a control Bus - its value will be zero by default.
// Map the Bus to the \force argument - this should silence the synths.
// Set the Bus value to 0.005 and enjoy.



// Note that you can also control multiple parameters of a particular Synth with a single Bus.