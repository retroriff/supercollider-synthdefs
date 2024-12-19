


(
// https://sccode.org/1-57b
/*~samples = 1024;
~frames = 128;
b = Buffer.allocConsecutive(~frames, s, ~samples * 2, completionMessage: { "done".postln; });*/

// SynthDef(\bass, {
//     var snd, wavetableControl, freq, ffreq;
//     freq = \freq.kr(440).varlag(0.1, warp: \exp);
//     wavetableControl = LFNoise2.kr(11).range(0, 1.0) ** 3;
//     ffreq = LFNoise2.kr(6.3).exprange(400, 8000);
//     snd = VOsc3.ar(b[0].bufnum + (wavetableControl * (~frames - 1)), *freq * [-0.1, 0, 0.1].midiratio);
//     snd = snd + (SinOsc.ar(freq * 0.5) * -3.dbamp);
//     snd = tanh(snd * 1.4);
//     snd = RLPF.ar(snd, ffreq, 0.8);
//     snd = snd * Env.adsr(0.1, 0.3, 0.7, 0.1).kr(2, \gate.kr(1));
//     snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
//     Out.ar(\out.kr(0), snd);
// }).add;


/*(
Pmono(\bass, *[
    octave: 3,
    amp: 1,
    dur: 3.0,
    scale: Scale.minor,
    degree: Pseq([7, 6, 2, 3, 5], inf),
    legato: 0.5
]).play;
)*/

// contributors so far: nathan ho



// if you like bass wobbles
//https://sccode.org/1-5cS

SynthDef(\wobble, {
	arg amp=1, out=0, wflo=1, wfhi=6, decay=0, gate=1, wfmax=8500, freq, iphase, delay = 0.4;
	var env = Linen.kr(gate, releaseTime: 0.01, doneAction: Done.freeSelf);
	var sig = MoogVCF.ar(
		in: (
			Pulse.ar([freq * 0.98, freq], mul:0.5) +
			PinkNoise.ar(LFNoise0.ar(2).range(0, 1.0)) +
			Saw.ar([freq, freq * 1.025], mul:2)
		).clip2(0.5),
		fco: LFCub.kr(
			freq:LFPulse.kr(0.25, iphase, width: 0.25).range(
				wflo, wfhi) ).exprange(40, wfmax),
		res: 0.4,
		mul: 2
	);
    delay = Greyhole.ar(sig * delay,
		delayTime:0.5, feedback:0.5, diff:0.4,
		damp:0.5, modDepth:0.8, modFreq:0.3);
    Out.ar(out, (sig + delay) * env * amp);
}).add;
)


/*
b = Bus.audio(s,2);

SynthDef("delayBus", { | outBus = 0, inBus, wet = 0.4 |
	var input = In.ar(inBus,2);
	var rev = Greyhole.ar(input * wet,
		delayTime:0.5, feedback:0.5, diff:0.4,
		damp:0.5, modDepth:0.8, modFreq:0.3);
    Out.ar(outBus, input + rev);
}).play(s, [\inBus,b]);

Pbind(
	\instrument, \wobble,
	\legato, 0.98, \out, b,
	\dur, 4,
	\wflo, 1,
	\wfhi, 0,
	\wfmax, Pseq([4,6,3,1,9]*500,inf),
	\iphase, 0.25,
	\degree, Pseq([2,0,-2,-2], 8), \octave, 3,
).play;
)
*/


/*
(
// https://lukaprincic.si/development-log/a-simple-808-beat-with-an-immature-bass-sound
// a quick hack, could be much improved
SynthDef("bass", { |out, midi = 32 , amp = 0.9, nharms = 10, pan = 0, gate = 1 |
    var audio = Blip.ar(midi.midicps, nharms, amp);
    var env = Linen.kr(gate, doneAction: Done.freeSelf);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env));

}).add;

~bass = Pbind(\instrument, \bass,
	\amp,				0.5,
	\nharms,            Pseq([4, 5, 2], inf),
    \dur,               Pseq([2, 1], 5),
	\midi, 				Pseq([32,Pshuf([32,44,47,23])], inf)
);
~part1 = Ppar([~bass], 8);

~part1.play;

)

*/