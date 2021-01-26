///// Sound Design / building simple/advanced Ugen Graphs

// 1. simple FM patch, constant vals
Ndef(\fm1, {
	var index = 1000;
	var mod = SinOsc.ar(40);
	var carrier = SinOsc.ar(440 + (mod * index));
	carrier.dup * 0.1;
}).play;

// same simple FM patch, variable vals as function arguments / synth parameters.
Ndef(\fm1, { arg freq = 440, modFreq = 40, index=1000;
	var mod = SinOsc.ar(modFreq);
	var carrier = SinOsc.ar(freq + (mod * index));
	carrier.dup * 0.1;
}).play;

Ndef(\fm1).gui;
// ToDo : make Specsto refine param ranges, e.g.
Spec.add(\index, [0, 1000, 5]);  // curve factor 5 = very concave



// 2. cross FM.
// still with params
(
Ndef(\xfm1, { arg freq = 440, modFreq = 40, index=100, index2=100;
	var fbIn = LocalIn.ar(2);
	var mod = SinOsc.ar(modFreq + (fbIn[0] * index2));
	var carrier = SinOsc.ar(freq + (mod * index));
	LocalOut.ar([carrier, mod]);
	[carrier, mod] * 0.1;
}).play;
);
Ndef(\xfm1).gui;
// one spec for each param
Spec.add(\freq, [1, 10000, \exp]);
Spec.add(\modFreq, [1, 10000, \exp]);
Spec.add(\index, [0, 1000, 5]);
Spec.add(\index2, [0, 1000, 5]);



// better rename the modules for symmetry - same topologiey.
(
Ndef(\xfm1, { arg freqA = 32, freqB = 9, modAtoB=540, modBtoA=240;
	var fbIn = LocalIn.ar(2);
	var sigB = SinOsc.ar(freqB + (fbIn[0] * modAtoB));
	var sigA = SinOsc.ar(freqA + (sigB    * modBtoA));
	LocalOut.ar([sigA, sigB]);
	[sigA, sigB] * 0.5;
}).play;
);
Spec.add(\freqA, [1, 10000, \exp]);
Spec.add(\freqB, [1, 10000, \exp]);
Spec.add(\modBtoA, [0, 1000, 5]);
Spec.add(\modAtoB, [0, 1000, 5]);


