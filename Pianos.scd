/*
* piano_MDA: Piano synth based on Mda Plugin
*/

(
SynthDef(\piano, {

	|amp=0.5, add=0, decay=0.8, freq=440, gate=1, hard=0.4, muffle=0.8, mul=1, out=0,
	release=0.8, random=0.1, stereo=0.2, stretch= 0.1, sustain= 0, tune=0.5,
	vel=80, velcurve=0.8, velhard=0.8, velmuff=0.8|

	var snd;

	snd = MdaPiano.ar(
		freq, gate, vel, decay, release, hard, velhard, muffle, velmuff, velcurve,
		stereo, tune, random, stretch, sustain, mul, add
	);

    snd = snd * EnvGen.kr(Env.asr(0, 1, 0.1), gate, doneAction: 2);
    Out.ar(out, snd * amp);

}).add;
)

// Pbind(\instrument, \piano, \dur, Pseq([0.5, 0.5, 0.5, 0.5, 1.5, 1, 1, 1, 1, 2, 0.5] ,inf), \midinote, Pseq([12, 8, 7, 0, [-12, 4, 12], [-12, 4, 12], [-12, 4, 12], [-11, 5, 12], [-11, 5, 12], [-9, 7, 12], 7] + 48, inf)).play;