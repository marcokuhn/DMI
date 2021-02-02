

(
Ndef(\vowelz, { |amp=1, freq = 176, freqShift= 1.02, freqDrift=1, formShift = 2, qShift=1, fold=1.4|

	var num=5, env, gen, ffreqs, lfmod, for, sig, bal, ruin, out;
	lfmod = LFDNoise3.kr({|i|XLine.kr(0.1, Rand(5, 8), [2, 3, 5]@@i)} ! num).range(0, freqDrift).midiratio;
	ffreqs = Vowel(\u, \soprano);
	// ffreqs.freqs.median.postcln;
	for = Formants.ar(
		freq.lag(0.4) *
		(freqShift.lag(0.2) ** [ -1, -0.5, 0, 0.5, 1].wrapExtend(num)).lag(0.05)
		* lfmod,
		ffreqs,
		formShift.lag(0.2) ** [0.9, 1, 1.1],
		0.8,
		qShift
	).postcln;
	for.shape.postln;
	bal = SplayAz.ar(2, for.flat);
	fold = fold.lag3(3);
	ruin = Fold.ar(bal * amp, fold.neg * 1.6, fold) * fold.reciprocal.sqrt;
	sig = ruin * AmpComp.kr(formShift * 2500.max(50));
	sig = LeakDC.ar(sig, 0.995);
	//out = OffsetOut.ar(0, ruin)
});
);


(
//  Ndef(\vowelz).gui

Ndef(\vowelz).addSpec(\freqDrift, [0.0, 12, 4, 0.1]);
Ndef(\vowelz).addSpec(\freqShift, [1, 0.10, 8]);
Ndef(\vowelz).addSpec(\qShift, [20, 1/20, \exp]);
Ndef(\vowelz).addSpec(\formShift, [1/20, 20, \exp]);
Ndef(\vowelz).addSpec(\freq, [1, 2000, \exp]);
Ndef(\vowelz).addSpec(\fold, [1, 0.005, -3]);

);

fork { s.sync; 0.1.wait; Ndef(\vowelz).end };
Ndef(\vowelz);


Ndef('vowelz').set('fold', 0.47, 'formShift', 0.18, 'freq', 16);
