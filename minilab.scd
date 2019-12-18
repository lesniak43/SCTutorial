
s.boot;
MIDIClient.init;
MIDIIn.connectAll;
MiniLab.connect; // (outLatency)
MIDIFunc.trace;
MIDIFunc.trace(false);

(
f = { arg n; { arg ... args; n.post; ": ".post; args.postln; }; };
MiniLab.bend(f.value("bend"));
MiniLab.deltaKnob(1, f.value("delta knob 1"));
MiniLab.deltaKnob(9, f.value("delta knob 9"));
MiniLab.keyboardNoteOn(f.value("k note on"));
MiniLab.keyboardNoteOff(f.value("k note off"));
16.do { arg n;
	MiniLab.knob(n+1, f.value("knob"+(n+1)));
};
MiniLab.knobButtonControlOn(1, f.value("knob button 1 on"));
MiniLab.knobButtonControlOn(9, f.value("knob button 9 on"));
MiniLab.knobButtonControlOff(1, f.value("knob button 1 off"));
MiniLab.knobButtonControlOff(9, f.value("knob button 9 off"));
8.do { arg n;
	MiniLab.padControlOn(n+9, f.value("pad control on"+(n+9)));
	MiniLab.padControlOff(n+9, f.value("pad control off"+(n+9)));
};
MiniLab.padNoteOn(f.value("pad note on"));
MiniLab.padNoteOff(f.value("pad note off"));
8.do { arg n;
	MiniLab.padPressure(n+1, f.value("pad pressure"+(n+1)));
};
MiniLab.slider(f.value("slider"));
MiniLab.sustainOn(f.value("sustain on"));
MiniLab.sustainOff(f.value("sustain off"));
)

(
MiniLab.setSlider(43);
16.do { arg n;
	MiniLab.setKnob(n+1, 43+n);
};
)

MiniLab.setPadColor(1, MiniLab.colors.choose);
(
t = Task({
	loop {
		MiniLab.setPadColor(16.rand, MiniLab.colors.choose);
		0.1.wait;
	};
});
t.play;
)

t.stop

// example: change color with pressure
(
8.do { arg n;
	MiniLab.padPressure(
		n+1,
		{ arg val, num, chan, src;
			MiniLab.setPadColor(n+1, MiniLab.colors[7-((val/16).floor.asInt)])
		},
	);
};
)

// example: change color with knobs
(
16.do { arg n;
	MiniLab.knob(
		n+1,
		{ arg val, num, chan, src;
			MiniLab.setPadColor(n+1, MiniLab.colors[7-((val/16).floor.asInt)])
		},
	);
};
)