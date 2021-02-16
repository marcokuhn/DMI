// more on FM



// Ramdom Seed parametrized FM perc. synths. HH ca. 2014 - 21
// 2 operators, 1 carrier.
(
SynthDef( \fmSanSimple, { arg seed = 239, amp=0.2, sustain=1;
	var sig, op1, op2;

	RandID.ir(10);  // choose a specific RandID (read help:)
	RandSeed.ir(1, seed);  // the Rand Seed may be set from outside at creation time.

	// 2 operators, with efficient FSinOScand random freqs, phases, amps
	op1 = FSinOsc.kr( ExpRand(10, 800), Rand(-pi, pi), Rand(-100, 400));
 	op2 = FSinOsc.ar( ExpRand(1, 8000), {Rand(-pi, pi)}!2 );

	sig = SinOsc.ar(
			ExpRand(0.2, 800) // carrier freq
			+ op1 // and adding op2
			* op2.madd( ExpRand(0.2, 100)) // scaled by op1
		,
		{Rand(-pi, pi)}!2,
		amp
	);

//	sig = sig * XLine.kr(1,0.001, tscaler, doneAction: 2);
	sig = EnvGen.ar(Env.perc(ExpRand(0.001, 0.2), sustain), doneAction: 2) * sig;
	Out.ar(0, sig);

}).add;
);

(instrument: \fmSanSimple, seed: 100.rand.postcln, amp: 0.25).play;
// pick favourite seeds
(instrument: \fmSanSimple, seed: 31.postcln, amp: 0.25).play;
(instrument: \fmSanSimple, seed: 55.postcln, amp: 0.25).play;
(instrument: \fmSanSimple, seed: 52.postcln, amp: 0.25).play;

(
// quick explorer
Pdef(\fmExplorer,
	Pbind(
		\instrument, \fmSanSimple,
		\seed, Pbrown(0, 100, 1, inf).asInteger.trace,
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
		\dur, 0.125,
		\legato, Pbrown(0.1, 1.5, 0.1)
	)
).play;
)


(instrument: \fmSanSimple, dur: 120, seed: 52, amp: 0.1).play;
(instrument: \fmSanSimple, dur: 120, seed: 5, amp: 0.1).play;
(instrument: \fmSanSimple, dur: 120, seed: 13, amp: 0.1).play;




// FM7 UGen from class library.

(
{
    var ctls, mods, chans, freq;
    freq = LFNoise0.kr(3).exprange(200, 310);
    ctls = [
        // freq, phase, amp
        [freq, 0, 1],
        [freq, 0, 1],
        [LFNoise2.kr(0.5).exprange(3, 80), 0, 1],
        [LFNoise2.kr(0.5).exprange(3, 800), 0, 1],
        [LFNoise2.kr(0.5).exprange(3, 800), 0, 1],
        [LFNoise2.kr(0.5).exprange(0.3, 10), 0, 1]
    ];
    mods = [
        { LFNoise1.kr(0.5).max(0) } ! 6 * MouseX.kr(0, 3),
        { LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3),
        { LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3),
        { LFNoise1.kr(0.5).max(0) } ! 6 * MouseX.kr(0, 3),
        { LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3),
        { LFNoise1.kr(0.5).max(0) } ! 6 * MouseY.kr(0, 3)
    ];
    chans = FM7.ar(ctls, mods).slice([0, 1]) * -12.dbamp;
}.play;
)


(
// Courtesy Fredrik Olofsson (2008)
Routine.run{
    var syn, time = 3; // Allow each patch to run for 3 sec
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
                FM7.ar(ctls, mods).slice(chans)*0.10;
            }.play)").postln.interpret;
        time.wait;
        syn.free;
    };
};
)








(
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





// Influx example - todo

Quarks.install("Influx");

(
// make an influx - fan-out 2 params to 8
a = Influx([\x, \y], [\a, \b, \c,\d, \e, \f, \g, \h, \i, \j], (x: 0.5, y: 0.1));

// or give the number of ins and outs:
// a = Influx(2, 8);
// or use a named Influx, an Idef:
a = Idef(\a, 2, 10);

// make plot/edit views for weights:
d = InfluxIOWGui(a); d.skipjack.dt = 0.05;

///// interactive gui example
// recommended for direct use:
InfluxKtlGui(a);

);
// try playing a boring sound with too many parameters
// note that .addSpec requires JITLibExtensions quark
(
Ndef(\a).addSpec(\intv, [-24, 24]);
Ndef(\a).addSpec(\timescale, [0.01, 10, \exp]);
Ndef(\a).addSpec(\curve, [-10, 10]);
Ndef(\a).addSpec(\ffreq, \freq);
Ndef(\a).addSpec(\loopnode, [0, 12]);

Ndef(\a).addSpec(\dens, [10, 1000]);
Ndef(\a).addSpec(\resfreq, \freq);
Ndef(\a).addSpec(\ringtime, [0.01, 1, \exp]);

Ndef(\a, { |freq=250, intv=19, timescale=1, curve=0, loopnode=0, dens = 10, resfreq = 500, ringtime = 0.01|
    var n = 15;
    var env = EnvGen.kr(
        Env({ 1.0.rand2 }!(n+1), {1.0.rand}!n, curve, releaseNode: n-1, loopNode: loopnode.min(n-3)),
        timeScale: timescale);
    var pitch = (env * [1, 0.33, -1] * intv).midiratio * freq;
    var form = Formant.ar(pitch, pitch.rotate(1) * 1.6, pitch.rotate(2) * 2.6);

    var dusty = Ringz.ar(Dust.ar(dens!3), resfreq * LFNoise0.kr([3, 5, 7], 0.5, 1), ringtime) * ((dens ** -0.5) * (ringtime ** -0.3)) ;
    Splay.ar(form * dusty);

}).play(vol: 0.25);
Ndef(\a).gui.moveTo(0, 50).skipjack.dt_(0.05);
);
Ndef(\a).play;

// connect the influx action to the Ndef
a.attachMapped(Ndef(\a));
);

a.attachMapped(Ndef(\xfm));
Ndef(\xfm).play;



