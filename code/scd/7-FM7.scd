// more on FM

s.boot;

// FM Exploration.

// Ramdom Seed parametrized FM perc. synths. HH ca. 2014 - 21
// 2 operators, 1 carrier.
(
SynthDef( \fmSanSimple, { arg seed = 123, amp=0.2, sustain=1;
	var carrier, op1, op2;

	RandID.ir(10);         // choose a specific RandID (read help:)
	RandSeed.ir(1, seed);  // the Rand Seed may be set from outside at creation time.

	// 2 operators, with efficient FSinOScand random freqs, phases, amps
	op1 = FSinOsc.kr(ExpRand(10, 800), Rand(-pi, pi),     Rand(-100, 400));
	op2 = FSinOsc.ar(ExpRand(1, 8000), {Rand(-pi, pi)}!2, ExpRand(0.2, 100));

	carrier = SinOsc.ar(
		ExpRand(0.2, 1000) // carrier freq
		+ op1 // and adding op2
		* op2 // scaled by op1
		,
		{ Rand(-pi, pi) }!2,
		amp
	);

	carrier = EnvGen.ar(Env.perc(ExpRand(0.01, 0.2), sustain), doneAction: 2)
	* carrier;
	Out.ar(0, carrier);

}).add;
);

(instrument: \fmSanSimple, seed: 100.rand.postcln, amp: 0.125).play;
// pick favourite seeds
(instrument: \fmSanSimple, seed: 31.postcln, amp: 0.25).play;
(instrument: \fmSanSimple, seed: 55.postcln, amp: 0.25).play;
(instrument: \fmSanSimple, seed: 52.postcln, amp: 0.25).play;

(
// quick explorer
Pdef(\fmExplorer,
	Pbind(
		\instrument, \fmSanSimple,
		\seed, Pbrown(0, 100, 5, inf).asInteger.trace,
		\amp, 0.25,
		\dur, 0.25
	)
).play;
);
(
// quick run through all of them:
Pdef(\fmExplorer,
	Pbind(
		\instrument, \fmSanSimple,
		\seed, Pseq((0 .. 100), 1).trace,
		\amp, 0.25,
		\dur, 0.5,
		\legato, Pbrown(0.1, 1.5, 0.1)
	)
).play;
)

// long notes.
(instrument: \fmSanSimple, dur: 120, seed: 52, amp: 0.1).play;
(instrument: \fmSanSimple, dur: 120, seed: 5, amp: 0.1).play;
(instrument: \fmSanSimple, dur: 120, seed: 333, amp: 0.1).play;

// ToDo:
// implement more internal control, Envelopes !
// external control




// play these sounds from a Sequencer nicked from 4-sequencing.scd.
Tdef(\seq_FM).set(\seed, 20211602); // today
Tdef(\seq_FM).set(\length, 8);
Tdef(\seq_FM).addSpec(\length, [1, 16, 0, 1]);
Tdef(\seq_FM).addSpec(\seed, [0, 200, 0, 1]);
Tdef(\seq_FM).gui;
(
Tdef(\seq_FM, { |envir|
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
				Synth(\fmSanSimple, [seed: 2000, sustain: exprand(0.1, 0.8)]);
			}{
				Synth(\fmSanSimple, [sustain: exprand(0.05, 0.4), seed: rrand(1, 5)]);
			};
			(1/4).wait;

		};
	}
}).play;
);

// a bit simplified; 'classic' 4 track drum machine paradigm with each trackrepeating the same note.
(
Tdef(\seq_FM).set(\seed, 107);

Tdef(\seq_FM, { |envir|
	inf.do{
		thisThread.randSeed = envir.seed.asInteger;

		envir.length.asInteger.do{|i|

			4.do{|track| // 4 "tracks"
				if(0.5.coin){
					Synth(\fmSanSimple, [seed: track, sustain: exprand(0.1, 0.8)]);
				}
			};
			(1/4).wait;

		};
	}
}).play;
);


// same with more controls: a slider for selecting each of the 4 tracks' sound.
(
Tdef(\seq_FM).set(\seed, 107);
Tdef(\seq_FM).set(\decay, 0.2);
Tdef(\seq_FM).set(\sound0, 0);
Tdef(\seq_FM).set(\sound1, 1);
Tdef(\seq_FM).set(\sound2, 2);
Tdef(\seq_FM).set(\sound3, 3);
Tdef(\seq_FM).addSpec(\sound0, [0, 200, 0, 1]);
Tdef(\seq_FM).addSpec(\sound1, [0, 200, 0, 1]);
Tdef(\seq_FM).addSpec(\sound2, [0, 200, 0, 1]);
Tdef(\seq_FM).addSpec(\sound3, [0, 200, 0, 1]);
)
(
Tdef(\seq_FM, { |envir|
	inf.do{
		thisThread.randSeed = envir.seed.asInteger;

		envir.length.asInteger.do{|i|

			4.do{|track| // 4 "tracks"
				var soundSeed = envir.at([\sound0, \sound1, \sound2, \sound3][track]);
				if(0.5.coin){
					Synth(\fmSanSimple, [seed: soundSeed, sustain: exprand(0.5, 1.5) * envir.decay ]);
				}
			};
			(1/4).wait;

		};
	}
}).play;
);

// change Tempo
TempoClock.default.tempo = 110 / 60;







// The FM7 appreciation thread :
"https://scsynth.org/t/the-fm7-appreciation-thread/3186".openOS;

// install FM7 UGen from:
"https://github.com/supercollider/sc3-plugins".openOS;
// and copy it here:
Platform.userExtensionDir.openOS;

/*
FM7 is an emulation of the famous Yamaha DX Series of FM Synths from the 80's.
It had 32 topologies connecting 6 "operators" - digital sine wave generators with modulation input for freq and phase.
see
https://reverbmachine.com/blog/exploring-the-yamaha-dx7/
and
https://yamahadx9.com/assets/images/volcaalgo3-1800x1100.png

Th SC emulation offers the 32 'algorithms' as
FM7.arAlgo(algo: 0, ctlMatrix, feedback: 0.0)
but also a much more flexible approach with
FM7.ar
with a full 6*6 modulaton matrix that allows to feed each output into each input.

*/


// explorations from help file

(
// algorithm 1 from DX7 with LFO'd freqs
{
	var ctls = [
		// freq, phase, amp
		[LFNoise1.kr(0.5).range(300, 310), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 310), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1]
	];
	FM7.arAlgo(1, ctls, MouseX.kr(0, 2))
}.play

)


(
// full matrix;  LFO'd freqs, a few modulations changing by mouse/LFO
{
	var ctls, mods, chans;
	ctls = [
		// freq, phase, amp
		[LFNoise1.kr(0.5).range(300, 310), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 310), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
		[LFNoise1.kr(0.5).exprange(3, 100), 0, 1]
	];
	mods = [
		[Line.kr(0, 0.001, 2), Line.kr(0.1, 0, 4), 0, MouseY.kr(0, 6), 0, 0],
		[MouseX.kr(0, 6), 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0]
	];
	chans = [0, 1];
	FM7.ar(ctls, mods).slice(chans) * -12.dbamp; // using "slice" to select specific channels
}.play;
)




(
// self-documenting stochastic code generation
// Courtesy Fredrik Olofsson (2008)
Routine.run{
	var syn, time = 3; // Allow each patch to run for a few sec
	inf.do{|i|
		("// FM7 patch"+i).post;
		syn= ("
(
var x= #"++({{{ |i| rrand(0.1, 0.5).round(0.5)}!4}!3}!6).asCompileString++";
var y= #"++({{{ |i| rrand(0.02, 1.6).round(0.5)}!4}!6}!6).asCompileString++";
{
var ctls= x.collect{|a| a.collect{|b| LFSaw.kr(*b)}};
var mods= y.collect{|a| a.collect{|b| LFPar.kr(*b)}};
var chans= #[0, 1];
FM7.ar(ctls, mods).slice(chans) * 0.2;
}.play)").postln.interpret;
		time.wait;
		syn.free;
	};
};
)






// 32 algorithms explorer
(
// generate a SynthDef for each
~fm7SynthNames = 32.collect{|algoNum| "fm7algo%".format(algoNum).asSymbol};

~fm7SynthNames.do{|synthName, algo|
	SynthDef(synthName, {|out=0, dur=0.01, sustain=0, freqScale=0.5, spread=0.25, pan=0, feedback=1.0, amp=0.5|
		var env = Env.perc.kr(gate:1, timeScale: dur * (1+sustain), doneAction: Done.freeSelf);
		var ctls =
		[
			// freq, phase, amp
			[freqScale * 300, pi.rand, 1],
			[freqScale * 2500, pi.rand, 1],
			[freqScale * SinOsc.ar(Rand(0.1,10.0)).exprange(3,100), 0, 1],
			[freqScale * LFNoise2.ar(10).exprange(1300,0.5), 0, 1],
			[freqScale * ExpRand(30,1500), pi.rand, 1],
			[freqScale * ExpRand(30,500), pi.rand, 1]
		];

		var sig = FM7.arAlgo(algo, ctls , feedback * 2.0);
		sig = Splay.ar(sig, spread: spread, center: pan);
		sig = sig * env * amp;

		Out.ar(out, sig);
	}).add;
};
)
(
// play them
Pbind(
	\instrument, Pseq(~fm7SynthNames, inf).trace,
	\dur, 1/8,
	\sustain, Pwhite(0.0,1.0),
	\feedback, Pshuf(Array.rand(8, 0.25,1.0),inf),
	\freqScale, Pxrand(Array.rand(8, 0.25,4.0),inf),
	\amp, Pwhite(0.125,0.5),
	\spread, Pwhite(0.0,1.0),
	\pan, Pwhite(-1.0,1.0)
).play;
)


