/*
dimensions on OSC mgs:

x [0..1280],
y [0..720],
lifespan [0..200],
hue [0..255]

*/

(
// well tuned, badly sounding
OSCdef(\particle, {|msg|
	msg = msg.drop(1);
	// msg.round(0.0001).postln;
	if(0.02.coin){
		(instrument: \particl,
			\freq: (720-msg[1]) * 4 + 200,  // y ax
			\pan: (msg[0] / 1280) *2-1,     // x ax
			\amp: (msg[2] / 150) / 20,      // life
			\feedback: (1-(msg[2].max(0) / 200)).squared, // life
		).play;
	}

}, "/particle").add
);

(
// badly tuned, well sounding
OSCdef(\particle, {|msg|
	// msg.drop(1).round(0.0001).postln;
	if(0.025.coin){
		(instrument: \particl,
			\freq: (720-msg[2] * 4 + 200),
			\pan: (msg[1] / 1280) *2-1,
			\amp: 1-(msg[2] / 720) / 10,
			\feedback: (msg[2].max(0) / 300).squared,
			sustain: 0.01
		).play;
	}

}, "/particle").add
);

(
SynthDef(\particl, {|out=0, sustain=0.001, freq=440, amp=0.1, pan=0, feedback=0|

	var snd = SinOscFB.ar(freq, feedback, amp);
	// var env = XLine.kr(1, 0.001, sustain, 1,0,2);
	var env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2);
	OffsetOut.ar(out, Pan2.ar(snd, pan, env));

}).add;
);

(instrument: \particl, \feedback: 1.0.rand).play;