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

// alternative syntax, uses default arguments instead of the ones provided in the SynthDef:
(instrument: \SOSsnare).play;
(instrument: \SOShats, freq: 7000, sustain: 0.2).play;
(instrument: \SOSkick, freq: 90).play;
(instrument: \SOStom, freq: 120, sustain: 0.4).play;

// ToDo:
// Anatomy of SynthDef;
// Make our own mini SynthDef.
// don't forget FreeSelf/Done and Out Ugen.

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
// start and stop buttons for each Tdef; pause/replay;
// "env" Button lets you access the Environment. Alt-click it for a GUI with sliders for numerical parameters!


// Tdefs as (stochastic) sequencers:

//  introducing the .coin and .choose methods.
// coin: random decision between true or false. probability of true from 0.0 to 1.0.
0.5.coin;
1.coin;
0.coin;
// results in Boolean!

// choose: random choice out of an Array.
[-100, 100].choose;
[\good, \bad, \ugly].choose;
["go out", "stay home", "undecided"].choose;  // a weather oracle

(
// 1. soloist
Tdef(\seq_1, { |envir|
	"starting the soloist".postln;
	inf.do{

		if(0.4.coin){ // 40% prob for kick
			Synth(\SOSkick, [freq: 90, beater_noise_level: 0.7, mod_index: 1, mod_freq: 120]);
		}{ // else (60% prob), either snare or hihat.
			Synth([\SOSsnare, \SOShats].choose, [sustain: 0.5, amp: 0.1]);
		};

		(1/4).wait;
	};
}).play;
);


// 2. constrained soloist: repeats a random pattern of length n

/*  introducing
a)- iteration over a list
b)- random seeding
c)- setting environment variables to the Tdef
*/

// a)- iteration over a list
l = [1, 23, 333]; // a List / Array
l.do{|element| element.postln }; // process array values one by one
l.do{|element| (element * 10).postln };
l.do{|element, i| [element, i].postln }; // second argument: index counter.
l.do{|element, i| (element * i).postln };


// b)- random seeding
Tdef(\seeed).set(\seed, 0); // c)- setting environment variables to the Tdef
Tdef(\seeed).gui; // here i see the value as a slider
(
Tdef(\seeed, { |envir|
	inf.do{
		// reset seed at EVERY STEP: always yields same result
		thisThread.randSeed = envir.seed.asInteger;
		100.rand.postln;
		(1/4).wait;
	}
}).play;
);
Tdef(\seeed).set(\seed, 1);    // try different vals
Tdef(\seeed).set(\seed, 1974); // try different vals

(
Tdef(\seeed, { |envir|
	inf.do{
		thisThread.randSeed = envir.seed.asInteger;
		// produce 8 vals at once.
		{ 100.rand}.dup(8).postln;
		(1/4).wait;
	}
}).play;
);
Tdef(\seeed).stop;



// the groovy soloist: repeats random patterns

// set some parameters to the Tdef
Tdef(\seq_2).set(\seed, 12343); // each seed will produce a different, DETERMINISTIC, random seq!
Tdef(\seq_2).set(\length, 12); // length of the seq
(
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
Tdef(\seq_2).addSpec(\length, [1, 16, 0, 1]); // from JITlib Extensions Quark
Tdef(\seq_2).addSpec(\seed, [0, 200, 0, 1]);


(
// more params randomized
Tdef(\seq_2, { |envir|
	var seq = [
		0.9, 0.1, 0.2, 0.1,  0.6, 0.1, 0.1, 0.3,
		0.7, 0.1, 0.1, 0.2,  0.5, 0.1, 0.8, 0.2
	];
	inf.do{
		thisThread.randSeed = envir.seed.asInteger;

		seq.wrapExtend(envir.length.asInteger).do{|val, i|
			if(val.coin){
				Synth(\SOSkick, [beater_noise_level: rrand(0.01, 0.1)]);
			}{
				Synth([\SOSsnare, \SOShats].choose, [sustain: exprand(0.05, 0.4)]);
			};
			(1/4).wait;
		};
	}
}).play;
);

// a second one to accompany, half time.
Tdef(\seq_3).set(\seed, 54);
Tdef(\seq_3).set(\length, 8);
Tdef(\seq_3).addSpec(\length, [1, 16, 0, 1]);
Tdef(\seq_3).addSpec(\seed, [0, 200, 0, 1]);

(
Tdef(\seq_3, { |envir|
	var seq;
	thisThread.randSeed = envir.seed.asInteger;
	seq = [
		0.9, 0.1, 0.2, 0.1,  0.6, 0.1, 0.1, 0.3,
		0.7, 0.1, 0.1, 0.2,  0.5, 0.1, 0.8, 0.2
	].scramble;
	inf.do{
		thisThread.randSeed = envir.seed.asInteger;

		seq.wrapExtend(envir.length.asInteger).do{|val, i|
			if(val.coin){
				Synth(\SOShats, [freq: 2000, sustain: exprand(0.1, 2)]);
			}{
				Synth([\SOSsnare, \SOStom].choose, [sustain: exprand(0.05, 0.4), freq: rrand(1, 5) * 100]);
			};
			(1/2).wait;
		};
	}
}).play;
);



// change Tempo for all. (try playing all Tdefs together)
TempoClock.default.tempo = 110 / 60;
TempoClock.default.tempo = 90 / 60;


/*
Further ToDo:
- add sound parameters to control via Tdef.set, add amp for mixing
- how about some pauses? Not every timeslot needs to be filled...
- breaks - shifting the Rand Seed from within every n measures?
- seq other vals, e.g. freq, sustain, ... by means of
  - fixed lists
  - stochastics (see above)
  - calculus; e.g. sieves
*/


