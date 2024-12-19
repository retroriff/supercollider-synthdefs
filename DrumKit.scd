(
SynthDef(\kick, {
    |amp = 1, atk = 0, freq = 100, mul = 1, out = 0, pan = 0|
    var env, kik, sig;
    sig = Mix(SinOsc.ar(XLine.kr(60 * [1, 1.05, 1.1], 60, 0.13), mul, amp));
    // kik = EnvGen.ar(Env.new([1, 0], [0.01])) / 6;
    env = EnvGen.kr(Env.perc(atk, 0.27), gate: 1, doneAction: 2);
    // sig = (sig + (kik * amp)) * env;
    sig = sig * env * 1.2;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\snare, {
    |amp = 1, out = 0, pan = 0|
    var env, noise, sig;
    noise = LPF.ar(WhiteNoise.ar(0.9), 5000, amp);
    sig = Pan2.ar(SinOsc.ar(108, 0, 0.5) + noise, pan, amp) * 1.5;
    env = EnvGen.kr(Env.perc(0, 0.13), gate: 1, doneAction: 2);
    Out.ar(out, sig * env);
}).add;

SynthDef(\hihat, {
    |amp = 1, out = 0, pan = 0, rate = 1|
    var env, sig;
    rate = rate * 8000;
    sig = HPF.ar(WhiteNoise.ar(amp), rate, 0.4);
    env = EnvGen.kr(Env.perc(0, 0.13), gate:1, doneAction:2);
    Out.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

)
