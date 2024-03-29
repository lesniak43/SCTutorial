
// Start the server.
// Make sure that the variable 'p' still holds a ProxySpace (check the previous lesson).
// You do not have to copy the code - run it from the other document and see that the variable is available globally.
p; // check the content, then open the mixer


// ADVANCED EXAMPLES

// Some UGens can generate their own signal (e.g. SinOsc), others can only transform the input (you've seen Mix, but this also applies to all effects - filters, reverb etc.).
// To chain multiple UGens you simply pass them as arguments to the following ones.

(
p[\example8] = {
    var signal = LFPulse.ar(freq: 110, mul: 0.3);
	signal = LPF.ar(in: signal, freq: 440); // you may reuse the variable if you don't need it anymore
	signal = Pan2.ar(signal); // check the documentation of Pan2
	signal; // this line is not required, but we leave it to be clear
};
)

// EXERCISE 7
// Add some more effects to the previous Example. Be creative!
// Think of an effect and then try to find a UGen that will do the job (e.g. google: SuperCollider UGen my_effect_name).
(
p[\exercise7] = {
    var signal = LFPulse.ar(freq: 110, mul: 0.3);
	signal = LPF.ar(in: signal, freq: 440);
	// signal = ...
	Pan2.ar(signal);
};
)
// Then read the guide called "Tour of UGens":
help("Tour of UGens");
// and see if you can find something interesting there.


// Although SinOsc doesn't require any input UGens, it will accept one if we ask it to.
p[\example9] = { SinOsc.ar(freq: SinOsc.ar(freq: 10, mul: 10, add: 440)); }; // vibrato
// It is a general rule that you can pass UGens instead of numbers when creating other UGens.

// EXERCISE 8
// Modify the Example 8 so that the sound oscilates between left and right speaker.
(
p[\exercise8] = {
    var signal = LFPulse.ar(freq: 110, mul: 0.3);
	signal = LPF.ar(in: signal, freq: 440);
	Pan2.ar(in: signal, ??? ); // check the documentation of Pan2 if you haven't done it yet
};
)


// Two important UGens are MouseX and MouseY.
p[\example10] = { SinOsc.ar(freq: MouseX.kr(20, 20000), mul: MouseY.kr(0, 1)); }; // "theremin", move your mouse

// Note that we used method 'kr' instead of 'ar', which stands for "control rate".
// Signal generated by 'kr' has lower sample rate, and therefore requires less CPU resources.
// Here the lower rate is sufficient, since you probably cannot change the mouse position >40k times per second.
// Some UGens support both 'ar' and 'kr' (e.g. SinOsc), others only one of them (MouseX/Y).
p[\example11] = { SinOsc.ar(freq: SinOsc.kr(freq: 10, mul: 10, add: 440)); }; // control rate vibrato, should be indistinguishable (by ear, not by computer!) from \example9


// EXERCISE 9
// Mouse control in Example 10 does not feel natural - read the documentation of MouseX (and MouseY), and then change the scale from linear to logarithmic (test both frequency and loudness).
// Hint: You also need to change the amplitude range! Replace "0" with "0.01".
// Why the logarithmic scale won't work with range 0 - 1?
p[\exercise9] = ... ;


// EXERCISE 10
// Phase modulation.
// Write a modulator that will control the carrier phase.
// The modulator should be an SinOsc, use the 'ar' method, and its frequency and amplitude should be controlled by mouse. It's frequency range should be from zero to at least 880 Hz.
// For very small frequencies you should hear vibrato, but we mainly expect to be able to change the timbre.
// Open scope and freqscope windows and observe how the signal changes its shape when you move your mouse.
//
(
p[\exercise10] = {
	var carrier, modulator;
	modulator = ... ;
	carrier = SinOsc.ar(freq: 440, phase: modulator);
	carrier ! 2;
};
)
// Now change SinOsc.ar to SinOsc.kr in the modulator and see the difference (look at the freqscope).


// To create an interesting timbre you may combine several simple waves as above, or use more complicated UGens (or combine complicated UGens etc., you get the idea).
// The sc3-plugins contain several examples of physical modeling that are certainly worth looking into.
// Let's copy the code from DWGBowed documentation:

(
p[\example10] = {
	var freq=440, amp=0.1, force=1, pos=0.07, c1=0.25, c3=31;
    var vib = Gendy1.kr(1,1,1,1,0.1, 4,mul:0.003,add:1);
    var son = DWGBowed.ar(freq*vib, amp,force,1,pos,0.1,c1,c3);
    son = DWGSoundBoard.ar(son);
    son = BPF.ar(son,118,1)+son;
    son = BPF.ar(son,430,1)+son;
    son = BPF.ar(son,490,1)+son;
    son = LPF.ar(son,6000);
	son ! 2;
};
)

// EXERCISE 11
// Try changing the parameters and see what happens. Then read the documentation of all five UGens used in the example, and also change the (default) values of arguments that are not explicitly stated in the code.
// Modify the code so that you can use sliders instead of having to manually set the values and run the code block.
// Don't forget to specify ranges of the sliders.

p[\exercise11] = ... ;