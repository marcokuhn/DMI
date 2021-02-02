// nonstandard cross FM - Joker Nies style
// hh ca. 2010...


(
// sound description in SC JITLib style:
Ndef(\xFMSHll, { |amp=0.1, freqA=440, freqB=44, modA_B=0.1, modB_A=0.9, shape=1, lag=0.05|
	var sig, fb = LocalIn.ar(2);
	var sh =  Latch.ar(fb, fb.reverse);
	var freqs =  2.pow([modB_A, modA_B]).pow(sh).lag2(lag) * [freqA, freqB].lag2(lag);
	var oscs = SinOsc.ar(freqs).pow(shape.lag(lag));
	LocalOut.ar(oscs);
	amp * oscs;
	// sig.collect{|si, i| // multichannel expansion
	// 	PanAz.ar(2, si, SinOsc.kr(Rand(0.1, 0.2), 0, Rand(1, 2)), amp)
	// }.sum;
});
);
// parameter range Specifications
Ndef(\xFMSHl).addSpec(\modA_B, [0, 6]);
Ndef(\xFMSHl).addSpec(\modB_A, [0, 6]);
Ndef(\xFMSHl).addSpec(\freqA, \widefreq);
Ndef(\xFMSHl).addSpec(\freqB, \widefreq);
// Ndef(\xFMSHl).addSpec(\modAB, \unipolar);
// Ndef(\xFMSHl).addSpec(\modBA, \unipolar);
Ndef(\xFMSHl).addSpec(\shape, [8, 1/8, \exp]);
Ndef(\xFMSHl).addSpec(\lag, [0, 5, 5]);


fork { s.sync; 0.1.wait; Ndef(\xFMSHl).end };
Ndef(\xFMSHl);
