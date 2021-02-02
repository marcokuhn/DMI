// audio in; make sure the proper audio drivers are set in OS's SYSTEM SETTINGS!

s.reboot;

Ndef(\in_out, {SoundIn.ar}).play;
s.scope; // display;
s.meter; // mo' display;

// we want stereo out! so 1st clear, then
Ndef(\in_out).clear;

// go stereo!
Ndef(\in_out, {
	SoundIn.ar.dup
}).play;

// mini stereo ringmod
Ndef(\in_out, {
	SoundIn.ar.dup
	* SinOsc.ar([441, 440])
}).play;

s.freqscope;

// ringmod + Mouse
Ndef(\in_out, {
	SoundIn.ar.dup
	* SinOsc.ar(
		MouseY.kr(1, 5000, 1) * [1, MouseX.kr(-10, 10)]
	)
}).play;



// Granulation.

// simplest, on live inputs: PitchShift Ugen
Ndef(\in_gran, {
	var in = SoundIn.ar.dup;
	PitchShift.ar(in, 0.2,
		MouseY.kr(-24, 24).midiratio
	)
}).play;

// more params
Ndef(\in_gran, { arg window=0.2, pitchDisp=0, timeDisp=0;
	var in = SoundIn.ar.dup;
	PitchShift.ar(in, window,
		MouseY.kr(-24, 24).midiratio,
		pitchDisp, timeDisp
	)
}).play;

Ndef(\in_gran).gui;
Spec.add(\window, [0.01, 5, \exp]);
Spec.add(\pitchDisp, [0, 1]);
Spec.add(\timeDisp, [0, 1]);

// add Feedback path.
Ndef(\in_gran, { arg window=0.2, pitchDisp=0, timeDisp=0, feedback=0.2;
	var in = SoundIn.ar.dup;
	var fb = LocalIn.ar(2).neg;
	var inMix = fb*feedback + in;

	var gran = PitchShift.ar(inMix, window,
		MouseY.kr(-24, 24).midiratio,
		pitchDisp, timeDisp
	);
	LocalOut.ar(gran);
	gran + in;
}).play;

Spec.add(\feedback, [0, 1.2]);

// Reading Grains from a Buffer: GrainBuf
GrainBuf.openHelpFile;

b.play;

(
var winenv;

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\buf_grain_test, { |out, gate = 1, amp = 1, sndbuf, envbuf|
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
    Out.ar(out,
        GrainBuf.ar(2, Impulse.kr(10), 0.1, sndbuf, LFNoise1.kr.range(0.5, 2),
            LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env)
}).add;
);

// use built-in env
x = Synth(\buf_grain_test, [\sndbuf, b, \envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);
// end of Help Example

Ndef(\buf_grain, { arg ratio = 1, dur=0.1, trigRate = 10, pan = 0, pos = 0, buf=0;
	GrainBuf.ar(2, Impulse.kr(trigRate), dur, buf, ratio, pos, 4, pan)
}).play;

Ndef(\buf_grain).set(\buf, b);
Ndef(\buf_grain).gui;


// amend
Ndef(\buf_grain, { arg ratio = 1, dur=0.1, trigRate = 10, pan = 0, pos = 0, buf=0;
	pos = pos + SinOsc.kr(1/5).range(-0.01, 0.01); // LFO pos
	GrainBuf.ar(2, Impulse.kr(trigRate), dur, buf, ratio, pos, 4, pan)
}).play;


Ndef(\buf_grain, { arg ratio = 1, overlap=4, trigRate = 10, pan = 0, pos = 0, buf=0;
	pos = pos.lag(5) + SinOsc.kr(1/5).range(-0.01, 0.01); // LFO pos
	GrainBuf.ar(2, Impulse.kr(trigRate), overlap/trigRate, buf, ratio, pos, 4, pan)
}).play;


Spec.add(\pos, [0,1]);

// Dust
Ndef(\buf_grain, { arg ratio = 1, overlap=4, trigRate = 10, pan = 0, pos = 0, buf=0;
	pos = pos.lag(5) + SinOsc.kr(1/5).range(-0.01, 0.01); // LFO pos
	GrainBuf.ar(2, Dust.kr(trigRate), overlap/trigRate, buf, ratio, pos, 4, pan)
}).play;


// jitter on the pb rate...
Ndef(\buf_grain, { arg ratio = 1, ratioDev=0, overlap=4, trigRate = 10, pan = 0, pos = 0, buf=0;
	pos = pos.lag(5) + SinOsc.kr(1/5).range(-0.01, 0.01); // LFO pos
	ratio = ratio + WhiteNoise.kr(ratioDev);
	GrainBuf.ar(2, Dust.kr(trigRate), overlap/trigRate, buf, ratio, pos, 4, pan)
}).play;

// ToDo: .. more internal modulators on virtually every param.
// more buffers
// live sampling. Buffer & RecordBuf Ugens.

