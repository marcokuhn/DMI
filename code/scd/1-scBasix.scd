// SuperCollider - simplest things first.
// stimulus-response | action - reaction | excitation - reaction | cause - effect


// material in https://cloud.medienhaus.udk-berlin.de/d/b9e88f4054ac47309024/

s.boot;    // boot the audio Server.
s.meter;  // some GUI
s.scope;


// sound tests:
// Cmd-Period to stop !!!
{ Saw.ar(20) * 0.1 }.play;
{ Saw.ar([200, 201]) * 0.1 }.play;
{ Saw.ar(2000 * LFSaw.ar([2, 3]/10)) * 0.1 }.play;
{ SinOsc.ar(800, 0, 1!2) }.play;

{ SinOsc.ar(660, 0, 0.5) }.play;
{ SinOsc.ar(660, SinOsc.ar(5, [0, 1], 10pi), 0.1) }.play;


// first tests using
KeyState
MouseButton, MouseX, MouseY

// example from
KeyState.openHelpFile;
// opens a GUI Window
(
w = Window.new("I catch keystrokes").background_(Color.rand);
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;  [char, keycode].postln; };
w.front;
)
// then execute this and then press the 'j' key.
// OSX people: Make sure to allow Keyboard in System Settings > “Security & Privacy / Input Monitoring” : click "+" and select the SC APP from Applications...
(
w.front; // something safe to type on
{ SinOsc.ar(800, 0, KeyState.kr(0, 0, 0.1)).dup }.play;
);

// a different tone for every key I hit.
{ SinOsc.ar(440, 0, KeyState.kr(0, 0, 0.1)).dup }.play; // a
{ SinOsc.ar(60.midicps, 0, KeyState.kr(8, 0, 0.1)).dup }.play; // c
{ SinOsc.ar(62.midicps, 0, KeyState.kr(2, 0, 0.1)).dup }.play; // d



(
// map all the letter keys to a single sine freq:
var playKeys= [  //more can be added
	($Z->6), ($X->7), ($C->8), ($V->9), ($B->11), ($N->45), ($M->46),

	($A->0), ($S->1), ($D->2), ($F->3), ($G->5), ($H->4), ($J->38), ($K->40), ($L->37),

	($Q->12), ($W->13), ($E->14), ($R->15), ($T->17), ($Y->16), ($U->32), ($I->34), ($O->31), ($P->35)
];
var freqs = playKeys.collect{|k, i| i * 50 + 100};
freqs.postln;
{
	Splay.ar(
		SinOsc.ar(freqs, 0,
			0.1 * KeyState.kr(playKeys.collect{|a| a.value}, lag:0)
		)
	)
}.play;
)



// more experimentation with the keyboard:

(
// let's make this a global data variable:
~playKeys= [
	($Z->6), ($X->7), ($C->8), ($V->9), ($B->11), ($N->45), ($M->46),

	($A->0), ($S->1), ($D->2), ($F->3), ($G->5), ($H->4), ($J->38), ($K->40), ($L->37),

	($Q->12), ($W->13), ($E->14), ($R->15), ($T->17), ($Y->16), ($U->32), ($I->34), ($O->31), ($P->35),

];
);


// some variants:
(
Ndef(\keys, {
	var freqs = ~playKeys.collect{|k, i| i * 50 + 100};
	var snds = SinOsc.ar(freqs, 0,
		0.1 * KeyState.kr(~playKeys.collect{|a| a.value}, lag:0)
	);
	snds.sum  ! 2 // simple dual mono
}).play;
);
(
// detune freqs
Ndef(\keys, {
	var freqs = ~playKeys.collect{|k, i| i ** 1.05 * 50 + 100};
	var snds = SinOsc.ar(freqs, 0,
		0.1 * KeyState.kr(~playKeys.collect{|a| a.value}, lag:0)
	);
	snds.sum  ! 2 // simple dual mono
}).play;
);

(
// multiply all freq instead of summing:
Ndef(\keys, {
	var freqs = ~playKeys.collect{|k, i| i ** 1.05 * 50 + 100};
	var snds = SinOsc.ar(freqs, 0,
		0.1 * KeyState.kr(~playKeys.collect{|a| a.value}, lag:0),
		1
	);
	HPF.ar(snds.product, 20) ! 2
}).play;
);

s.freqscope; // check to see sidebands
(
Ndef(\keys, {
	var freqs = ~playKeys.collect{|k, i| i ** 0.95 * 50 + 100};
	var snds = SinOsc.ar(freqs, 0,
		0.1 * KeyState.kr(~playKeys.collect{|a| a.value}, lag:0),
		1
	);
	HPF.ar(snds.product, 20) ! 2
}).play;
);
(
// more complex freq series
Ndef(\keys, {
	var freqs = ~playKeys.collect{|k, i| i + 1 * 50};
	var snds = SinOsc.ar(freqs, 0,
		KeyState.kr(~playKeys.collect{|a| a.value}, lag:0),
		1
	).pow(MouseY.kr(0.5, 2, 1));
	snds.postln;
	// freqs.plot;
	HPF.ar(snds.product * 0.1, 20) ! 2
}).play;
);





// keeping stopping the sound and re-starting is boring ... how about re-writing the Synth as an Ndef?
Ndef(\keystate, { SinOsc.ar(880, 0, KeySe.kr((0 .. 67), 0, 0.5, 0).sum) }).play;

Ndef(\keystate).gui;

Ndef(\keystate, {
	var keys = KeyState.kr((0 .. 67), 0, 0.5, 0);
	SinOsc.ar(880, 0, keys.sum).dup
}).play;





// mouse button:
Ndef(\moustate, { |freq=880| SinOsc.ar(freq, 0, MouseButton.kr(0, 0.2, 0)).dup }).play;
Ndef(\moustate).gui;

// mouse button + Mouse X Y Axis
Ndef(\moustateFB, {
	var freq = MouseX.kr(1, 1000, 1,  5);
	var feedback = MouseY.kr(0, 3, 0, 0.2);
	var sig = SinOscFB.ar(freq, feedback * [1, 1.01], MouseButton.kr(0, 1, 0));
	HPF.ar(sig, 20) * 0.2;
}).play;
Ndef(\moustateFB).gui;


// move towards PM/FM and Slider control .. in class.



