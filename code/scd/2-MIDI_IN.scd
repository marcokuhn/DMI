// 2-MIDI IN


// initialize MIDI:
MIDIClient.init;
MIDIIn.connectAll;

// check:
MIDIClient.sources;

// quick test: .trace dumps all incoming MIDI.
MIDIFunc.trace;        // trace on
MIDIFunc.trace(false); // trace off


// we use MIDIdef, as we can overwrite/rewrite the Function

// basic post-all test, matching our Teensy Example.
MIDIdef.cc(\test,  {arg ...args; args.postln}, (0..3), 0); // filter for MIDI CCnum 0 to 3, Chan 0

// pretty printing:
MIDIdef.cc(\test,  {arg val, cc, chan, source;
	postf("CCnum %: \t val: %\n", cc, val)
}, (0..3), 0);

// silent..
MIDIdef.cc(\test,  {arg val, cc, chan, source; }, (0..3), 0);

// setting parameters to an Ndef:
Ndef(\sines4, { arg note1, note2, note3, note4, lagSec=0.1;
	var sig = SinOsc.ar([note1, note2, note3, note4].lag(lagSec).midicps);
	Splay.ar(sig) * 0.1
}).play;



Ndef(\sines4).gui;
Spec.add(\note1, \midi);
Spec.add(\note2, \midi);
Spec.add(\note3, \midi);
Spec.add(\note4, \midi);

Ndef(\sines4).set(\note1, 127.rand);
Ndef(\sines4).set(\note2, 127.rand);
Ndef(\sines4).set(\note3, 127.rand);
Ndef(\sines4).set(\note4, 127.rand);

MIDIdef.cc(\test,  {arg val, cc, chan, source;
	var key = [\note1, \note2, \note3, \note4][cc];
	Ndef(\sines4).set(key, val);
}, (0..3), 0);


// more refined MAPPING, more Synth Functions, ...