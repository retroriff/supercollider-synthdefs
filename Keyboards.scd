(

/*
Piano_rhodeySC: FM Rhodes Synthethizer
By Nathan Ho aka Snappizz
http://sccode.org/1-522
*/

SynthDef(\rhodes, {

	// Standard arguments
	|amp = 0.1, freq = 440, gate = 1, out = 0, pan = 0,
    // All of these range from 0 to 1
    lfoDepth = 0.1, lfoSpeed = 0.4, mix = 0.2, modIndex = 0.2, vel = 0.8|

	var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    lfoSpeed = lfoSpeed * 12;

    freq = freq * 2;

    env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
    env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
    env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
    env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

    osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
    osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
    osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
    osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
    snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

    // Using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
    snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;

/*
Fender Rhodes
By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
*/

SynthDef(\everythingrhodes, {

	|amp = 0.1, cutoff = 2000, freq = 440, gate = 1, lforate = 4.85, lfowidth = 0.5, out = 0, pan = 0, rq = 0.5|

	var pulse, filter, env;

	pulse = Pulse.ar(freq*[1,33.5.midiratio],[0.2,0.1],[0.7,0.3]);

	env = EnvGen.ar(Env.adsr(0.0,1.0,0.8,3.0), gate, doneAction:2);

	// Keyboard tracking filter cutoff
	filter = BLowPass4.ar(pulse,(cutoff*(env.squared))+200+freq,rq);

	Out.ar(out, Pan2.ar(Mix(filter)*env*amp,pan));

}).add;

/*
harpsichord_simple: Simple and Light Harpsichord
By Bruno Ruviaro
https://github.com/brunoruviaro/
*/

SynthDef(\harpsichord, {

	|amp = 0.1, freq = 440, out = 0, pan = 0|

	var env, snd;

	env = Env.perc(level: amp).kr(doneAction: 2);
	snd = Pulse.ar(freq, 0.25, 0.75);
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));

}).add;

)