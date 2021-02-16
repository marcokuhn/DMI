// trivial machine vs. nontrivial machines
// a' la Heinz v. Foerster

// trivial machine

// black box: a simple function that alters input according to a simple rule
f = {|in| var out = in + 1 % 4; out };

// amachine that keeps generating putput from the black box
Tdef(\triv, {
	var in = 0, out;
	loop{
		out = f.(in);
		"in %: , out: % \n".postf(in, out);
		in = in + 1 % 4;
		0.5.wait;
	}
}).play;

// non trivial machine

// black box: a simple function that alters input according to a simple rule
// AND the previous result
g= {|in, prevIn| var out = in + 1 + prevIn % 4; out };
// machine
Tdef(\nontriv, {
	var in = 0, out=0;
	loop{
		out = g.(in, out);
		"in %: , out: % \n".postf(in, out);
		in = in + 1 % 4;
		0.5.wait;
	}
}).play;

// sonified:
s.boot;
Tdef(\trivSon, {
	var in = 0, out;
	loop{
		out = f.(in);
		"in %: , out: % \n".postf(in, out);
		(note: out).play;
		in = in + 1 % 4;
		0.5.wait;
	}
}).play;

// generates a longer loop
Tdef(\nontrivSon, {
	var in = 0, out=0;
	loop{
		out = g.(in, out);
		"in %: , out: % \n".postf(in, out);
		(note: out).play;
		in = in + 1 % 4;
		0.5.wait;
	}
}).play;

// alternative algorithms
g= {|in, prevIn| var out = 3 * in +  prevIn * 3  % 4; out };     // doubling
g= {|in, prevIn| var out = (3 * in + ( prevIn)) * 3  % 7; out }; // greater range




//historically aware / aging: f depends on overall incrementing counter

h = {|in, cnt| var out = in + ( cnt%3) % 4; out };

Tdef(\nontrivSonRecursive, {
	var out=0, cnt=0;
	loop{
		out = h.(out, cnt);
		"out: % \n".postf( out);
		(note: out.round).play;  // round the note to Integer
		cnt = cnt+1;
		0.5.wait;
	}
}).play;

// alternative algorithms
h = {|in, cnt| var out = in + ( cnt%11) * 3  % 4; out };
h = {|in, cnt| var out = in + 1 * ( cnt >> in)   % 4; out };
