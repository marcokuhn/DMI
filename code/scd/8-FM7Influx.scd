// HH FM7 -- Influx example
/*
this patch is to demo the use of metacontrol strategies when confronted with absurdly large parameter spaces.
*/



// background: SC FM7 Ugen
// The FM7 appreciation thread :
"https://scsynth.org/t/the-fm7-appreciation-thread/3186".openOS;

// The FM7 Ugen is not in the standard distro, but you can easily download it from:
"https://github.com/supercollider/sc3-plugins".openOS;
// and paste it here:
Platform.userExtensionDir.openOS;
// recompile, then...

// check FM7's help file a bit:
"FM7".help;


// Now, we use it in this Ndef with FULL parametrization.
s.boot;  s.freqscope;
Ndef(\fm7).clear;
(
// create param names
~modNames = {|i|{|j|("mod"++i++j).asSymbol } ! 6 } ! 6;
~freqNames = {|i| ("freq"++i).asSymbol } ! 6;
// create param ranges (Specs)
~modNames.flat.collect{|n| Ndef(\fm7).addSpec(n, [0, 220, 12]); };
~freqNames.collect{|n| Ndef(\fm7).addSpec(n, [1, 50, 12]); };
Ndef(\fm7).addSpec(\chan1, [0, 5, \lin]);
Ndef(\fm7).addSpec(\chan2, [0, 5, \lin]);

Ndef(\fm7, {
	var mods =  // mod table as control inputs
	{|i|
		{|j|
			var name = ("mod"++i++j).asSymbol;
			name.kr( 1.0.linrand )
		} ! 6
	} ! 6;
	var ctls = ~freqNames.collect{|name| [name.kr(100.rand), 0, 1] };

	var chans = [\chan1.kr, \chan2.kr];
	var snd = FM7.ar(ctls, mods); // actual synth
	// snd = snd.slice(chans);
	var stereo = chans.collect{ |chan, i| SelectX.ar(chan, snd) }; // 'radio tune' one of the 6 channels for each of the 2 out channels
	stereo
}).play;
);

Ndef(\fm7).gui; // ui! too many sliders!


// slow x-fade
Ndef(\fm7).fadeTime_(4);

// new batch of mods:
Ndef(\fm7).set( * ~modNames.flat.collect{|k| [k, [0, 10.0.linrand.linrand].choose ] }.flat  );

// new batch of mods; smooth crossfade
Ndef(\fm7).xset( * ~modNames.flat.collect{|k| [k, [0, 10.0.linrand.linrand].choose ] }.flat  );



//== now, play it thru an Influx Metamapper.

// needs Quark installed only once: execute this line, then reboot interpreter. (need git tools installed on your comp.)
Quarks.install("Influx");

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
~modNames.flat.collect{|n| Ndef(\fm7).addSpec(n, [0, 20, 12]); };
~freqNames.collect{|n| Ndef(\fm7).addSpec(n, [50, 1000, 12]); };
a.attachMapped(Ndef(\fm7));
