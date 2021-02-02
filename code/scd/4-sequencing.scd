// sequencing sounds in time (not on timeline!-)

// play a SynthDef as an Event:
// load SynthDefs from neighbouring file:
s.boot;
"DrumSynths.scd".loadRelative;

// 4 sounds are defined there:
Synth(\SOSkick);
Synth(\SOSsnare);
Synth(\SOStom);
Synth(\SOShats);

// alternatice syntax, uses default arguments instead of the one provided in the SynthDef:
(instrument: \SOSsnare).play;
(instrument: \SOShats, freq: 7000, sustain: 0.2).play;
(instrument: \SOSkick, freq: 90).play;
(instrument: \SOStom, freq: 120, sustain: 0.4).play;

// ToDo: Anatomy of SynthDef; Make our own mini SynthDef.
// don't forget FreeSelf and Out Ugen.

//================================================================

// A Task structures things in time:
Tdef(\basic, { |envir|
	inf.do{
		"yolo!".scramble.postln;
		1.wait;
	};
}).play;

// here we see what's going on:
TdefAllGui.new;



// Tdefs as (stochastic) sequencers:
(
// 1. soloist
Tdef(\seq_1, { |envir|
	inf.do{
		if(0.4.coin){
			Synth(\SOSkick, [freq: 90, beater_noise_level: 0.7, mod_index: 1, mod_freq: 120]);
		}{
			Synth([\SOSsnare, \SOShats].choose, [sustain: 0.5, amp: 0.1]);
		};
		(1/2).wait;
	};
}).play;
);

(
// 2. constrained soloist: repeats a random pattern of length n

// set some parameters to the Tdef
Tdef(\seq_2).set(\seed, 12343); // each seed will produce a different, DETERMINISTIC, random seq!
Tdef(\seq_2).set(\length, 12); // length of the seq


Tdef(\seq_2, { |envir|
	var seq = [
		0.9, 0.1, 0.2, 0.1,  0.6, 0.1, 0.1, 0.3,
		0.7, 0.1, 0.1, 0.2,  0.5, 0.1, 0.8, 0.2
	];
	inf.do{
		thisThread.randSeed = envir.seed.asInteger;
		seq.wrapExtend(envir.length.asInteger).do{|val, i|
			if(val.coin){
				Synth(\SOSkick);
			}{
				Synth([\SOSsnare, \SOShats].choose);
			};
			(1/4).wait;
		};
	}
}).play;
);

Tdef(\seq_2).gui;
Tdef(\seq_2).addSpec(\length, [1, 16, 0, 1]);
Tdef(\seq_2).addSpec(\seed, [0, 200, 0, 1]);

TempoClock.default.tempo = 110 / 60;


/*
ToDo: seq other vals, e.g. freq, sustain, ...
by means of
- fixed lists
- stochastics (see above)
- calculus; e.g. sieves

*/
