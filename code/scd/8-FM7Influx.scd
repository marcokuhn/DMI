// HH FM7 -- Influx example
/*
this patch is to demo the use of metacontrol strategies when contronted with absurdly huge parameter spaces.
*/


///=== FM Ndef with Ndef/Influx
Ndef(\fm7).clear;
(
// FM7 full matrix is 2 x 6 x 6 = 72 variables
~modNames = {|i|{|j|("mod"++i++j).asSymbol } ! 6 } ! 6;
~freqNames = {|i| ("freq"++i).asSymbol } ! 6;

~modNames.flat.collect{|n| Ndef(\fm7).addSpec(n, [0, 220, 12]); };
~freqNames.collect{|n| Ndef(\fm7).addSpec(n, [1, 50, 12]); };
Ndef(\fm7).addSpec(\ffreq, [75, 8000, \exp]);
Ndef(\fm7).addSpec(\rq, [2, 0.1, \exp]);
Ndef(\fm7).addSpec(\chan1, [0, 5, \lin]);
Ndef(\fm7).addSpec(\chan2, [0, 5, \lin]);

Ndef(\fm7, { arg ffreq=500, rq=1.5;
	var snd;
	var mods = {|i|{|j| // mod table as control inputs
		var name = ("mod"++i++j).asSymbol;
		name.kr( 1.0.linrand )
	} ! 6 } ! 6;
	// var ctls =  { [ExpRand(1, 440), 0, 1] } ! 6; // freqs randomized
	var ctls =  ~freqNames.collect{|name| [name.kr(100.rand), 0, 1] };

	var chans = [\chan1.kr, \chan2.kr];
	snd = FM7.ar(ctls, mods); // actual synth
	// snd = snd.slice(chans);
	snd = chans.collect{ |chan, i| SelectX.ar(chan, snd) }; // we select 2 channels out of the 6
	RLPF.ar(snd, ffreq, rq, 0.1) + snd.madd(0.01); // a bit of filtering doesn't hurt
}).play;
);

Ndef(\fm7).gui; // ui! too many sliders!

// new freqs, crossFade with fadeTime:
Ndef(\fm7).fadeTime_(4);
Ndef(\fm7).send;

// new batch of mods:
Ndef(\fm7).set( * ~modNames.flat.collect{|k| [k, [0, 10.0.linrand.linrand].choose ] }.flat  );

// smooth crossfade
Ndef(\fm7).xset( * ~modNames.flat.collect{|k| [k, [0, 10.0.linrand.linrand].choose ] }.flat  );



//== now, play it thru an Influx
Quarks.install("Influx"); // needs Quark installed only once: execute this line, then reboot interpreter. (need git tools installed on your comp.)

(
// make an influx - fan-out 2 params to 38
// a = Influx([\x, \y, \z, \w], [\aa, \bb] ++ ~modNames.flat, (x: 0.5, y: 0.1));
a = Influx(4, Ndef(\fm7).controlKeys.size);
///// interactive gui  // recommended for direct use:
InfluxKtlGui(a);
// attach Influx to the Ndef
a.attachMapped(Ndef(\fm7));
// a.attachToButton(0, Ndef(\fm7));
);
/*
you can now play ALL params with just one 2D SLider!
for a different set of parameter distributions, press "RANDOM" on the Influx gui.
for deeper understanding:
"https://www.3dmin.org/wp-content/uploads/2014/03/Campo_2014.pdf".openOS
*/

// re-tune param ranges (aka Specs) for differnt timbral ranges

// orig
~modNames.flat.collect{|n| Ndef(\fm7).addSpec(n, [0, 220, 12]); };
~freqNames.collect{|n| Ndef(\fm7).addSpec(n, [1, 50, 12]); };

// lo freq, hi mod
~modNames.flat.collect{|n| Ndef(\fm7).addSpec(n, [1, 100, 12]); };
~freqNames.collect{|n| Ndef(\fm7).addSpec(n, [10, 150, 12]); };

// hi freq, lo mod
~modNames.flat.collect{|n| Ndef(\fm7).addSpec(n, [0, 10, 12]); };
~freqNames.collect{|n| Ndef(\fm7).addSpec(n, [50, 1000, 12]); };
