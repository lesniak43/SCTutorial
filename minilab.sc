
// https://forum.arturia.com/index.php?topic=93116.0
// https://forum.arturia.com/index.php?topic=93714.0
// https://www.untergeek.de/2014/11/taming-arturias-beatstep-sysex-codes-for-programming-via-ipad/


// cc numbers:
//   with value:
//     knobs: 7, 74, 71, 76, 77, 93, 73, 75, 116, 18, 19, 16, 17, 91, 79, 72
//       (note that 1 and 9 require shift to be pressed)
//     deltaKnobs (1 and 9): 112, 114
//     slider: 1
//   on/off:
//     knobButtons (1 and 9): 113, 115
//     sustain: 64
//     pads (9-16): 22-29

// pads 1-8:
//   notes 36-43, channel 9
//   polytouch 36-43, channel 9

// set deltaKnobs (1 and 9): 0x30, 0x33

MiniLab {

	classvar <srcID, <midiout, <padNotesRange, <padNotesChannel, <defaultChannel, <sustainControlNum, <deltaKnobRestValue, <sliderControlNum, <controlOnValue, <controlOffValue, <sliderSysexCode, <colors;

	*initClass {
		padNotesRange = (36..43);
        padNotesChannel = 9;
		defaultChannel = 0;
		sustainControlNum = 64;
		sliderControlNum = 1;
		deltaKnobRestValue = 64;
		controlOnValue = 127;
		controlOffValue = 0;
		sliderSysexCode = 0x40;
		colors = [\white, \red, \green, \blue, \cyan, \magenta, \yellow, \black];
    }

	*connect { arg outLatency=nil;
		midiout = MIDIOut.newByName("Arturia MiniLab mkII", "Arturia MiniLab mkII MIDI 1");
		srcID = MIDIIn.findPort("Arturia MiniLab mkII", "Arturia MiniLab mkII MIDI 1").uid;
		if (outLatency.notNil) {
			midiout.latency = outLatency;
		};
	}

	*padNumToControlNum { arg n;
		^n+13;
	}

	*padControlNumToNum { arg n;
		^n-13;
	}

	*knobButtonNumToControlNum { arg n;
		^(1: 113, 9: 115)[n];
	}

	*knobButtonControlNumToNum { arg n;
		^(113: 1, 115: 9)[n];
	}

	*knobNumToControlNum { arg n;
		^[7, 74, 71, 76, 77, 93, 73, 75, 116, 18, 19, 16, 17, 91, 79, 72][n-1];
	}

	*knobControlNumToNum { arg n;
		^[7, 74, 71, 76, 77, 93, 73, 75, 116, 18, 19, 16, 17, 91, 79, 72].detectIndex(
			{arg x; x==n;}
		);
	}

	*knobNumToSysexCode { arg n;
		^[0x32, 0x01, 0x02, 0x09, 0x0b, 0x0c, 0x0d, 0x0e, 0x35, 0x03, 0x04, 0x0a, 0x05, 0x06, 0x07, 0x08][n-1];
	}

	*padNumToSysexColorCode { arg n;
		^111+n;
	}

	*colorToSysexColorCode { arg c;
		^(on: 0x7f, white: 0x7f, red: 0x01, green: 0x04, blue: 0x10, cyan: 0x14, magenta: 0x11, yellow: 0x05, black: 0x00, off: 0x00)[c];
	}

	*deltaKnobNumToControlNum { arg n;
		^(1: 112, 9: 114)[n];
	}

	*deltaKnobControlNumToNum { arg n;
		^(112: 1, 114: 9)[n];
	}


	// SECTION: PAD PRESSURE

	*padPressure { arg number, func;
		var func_ = { arg val, num, chan, src;
			func.value(val, num-padNotesRange[0]+1, chan, src);
		};
		MIDIdef.polytouch(
			key: ("MiniLab_padPressurePolytouch_"++number).asSymbol,
			func: func_,
			noteNum: padNotesRange[number-1],
			chan: padNotesChannel,
			srcID: srcID
		);
		MIDIdef.noteOff(
			key: ("MiniLab_padPressureNoteOff_"++number).asSymbol,
			func: func_,
			noteNum: padNotesRange[number-1],
			chan: padNotesChannel,
			srcID: srcID
		);
	}

	// SECTION: PAD COLORS

	*setPadColor { arg number, color;
		midiout.sysex(
			Int8Array[0xf0, 0x00, 0x20, 0x6b, 0x7f, 0x42, 0x02, 0x00, 0x10, this.padNumToSysexColorCode(number), this.colorToSysexColorCode(color), 0xf7])
		;
	}

	// SECTION: CC CONTINUOUS - SET VALUE

	*setKnob { arg number, value;
		midiout.sysex(
			Int8Array[0xf0, 0x00, 0x20, 0x6b, 0x7f, 0x42, 0x02, 0x00, 0x00, this.knobNumToSysexCode(number), value, 0xf7]
		);
	}

	*setSlider { arg value;
		midiout.sysex(
			Int8Array[0xf0, 0x00, 0x20, 0x6b, 0x7f, 0x42, 0x02, 0x00, 0x00, sliderSysexCode, value, 0xf7]
		);
	}

	// SECTION: CC CONTINUOUS

	*slider { arg func;
		MIDIdef.cc(
			key: \MiniLab_slider,
			func: func,
			ccNum: sliderControlNum,
			chan: defaultChannel,
			srcID: srcID
		);
	}

	*knob { arg number, func;
		MIDIdef.cc(
			key: ("MiniLab_knob_"++number).asSymbol,
			func: func,
			ccNum: this.knobNumToControlNum(number),
			chan: defaultChannel,
			srcID: srcID
		);
	}

	*deltaKnob { arg number, func;
		var func_ = { arg val, num, chan, src;
			if ( val != deltaKnobRestValue ) {
				val.postln;
				func.value(val - deltaKnobRestValue, num, chan, src);
			};
		};
		MIDIdef.cc(
			key: ("MiniLab_deltaKnob_"++number).asSymbol,
			func: func_,
			ccNum: this.deltaKnobNumToControlNum(number),
			chan: defaultChannel,
			srcID: srcID
		);
	}

	// SECTION: CC ON/OFF

	*knobButtonControlOn { arg number, func;
		MIDIdef.cc(
			key: ("MiniLab_knobButtonControlOn_"++number).asSymbol,
			func: func,
			ccNum: this.knobButtonNumToControlNum(number),
			chan: defaultChannel,
			argTemplate: controlOnValue,
			srcID: srcID
		);
	}

	*knobButtonControlOff { arg number, func;
		MIDIdef.cc(
			key: ("MiniLab_knobButtonControlOff_"++number).asSymbol,
			func: func,
			ccNum: this.knobButtonNumToControlNum(number),
			chan: defaultChannel,
			argTemplate: controlOffValue,
			srcID: srcID
		);
	}

	*padControlOn { arg number, func;
		MIDIdef.cc(
			key: ("MiniLab_padControlOn_"++number).asSymbol,
			func: func,
			ccNum: this.padNumToControlNum(number),
			chan: defaultChannel,
			argTemplate: controlOnValue,
			srcID: srcID
		);
	}

	*padControlOff { arg number, func;
		MIDIdef.cc(
			key: ("MiniLab_padControlOff_"++number).asSymbol,
			func: func,
			ccNum: this.padNumToControlNum(number),
			chan: defaultChannel,
			argTemplate: controlOffValue,
			srcID: srcID
		);
	}

	*sustainOn { arg func;
		MIDIdef.cc(
			key: \MiniLab_sustainOn,
			func: func,
			ccNum: sustainControlNum,
			chan: defaultChannel,
			argTemplate: controlOnValue,
			srcID: srcID
		);
	}

	*sustainOff { arg func;
		MIDIdef.cc(
			key: \MiniLab_sustainOff,
			func: func,
			ccNum: sustainControlNum,
			chan: defaultChannel,
			argTemplate: controlOffValue,
			srcID: srcID
		);
	}

	// SECTION: NOTES

	*padNoteOn { arg func;
		var func_ = { arg val, num, chan, src;
			func.value(val, num-padNotesRange[0]+1, chan, src);
		};
		MIDIdef.noteOn(
			key: \MiniLab_padNoteOn,
			func: func_,
			noteNum: padNotesRange,
			chan: padNotesChannel,
			srcID: srcID
		);
	}

	*padNoteOff { arg func;
		var func_ = { arg val, num, chan, src;
			func.value(val, num-padNotesRange[0]+1, chan, src);
		};
		MIDIdef.noteOff(
			key: \MiniLab_padNoteOff,
			func: func_,
			noteNum: padNotesRange,
			chan: padNotesChannel,
			srcID: srcID
		);
	}

	*keyboardNoteOn {arg func;
		MIDIdef.noteOn(
			key: \MiniLab_keyboardOn,
			func: func,
			chan: defaultChannel,
			srcID: srcID
		);
	}

	*keyboardNoteOff {arg func;
		MIDIdef.noteOff(
			key: \MiniLab_keyboardOff,
			func: func,
			chan: defaultChannel,
			srcID: srcID
		);
	}

	*bend {arg func;
		MIDIdef.bend(
			key: \MiniLab_bend,
			func: func,
			chan: defaultChannel,
			srcID: srcID
		);
	}

}
