/*
HenonN: using the non-interpolated Henon Ugen as a synth.

Contains a LeakDC Ugen to stop any DC bias in the signal from disturbing the rest of the mix.

Arguments for a, b, x0 and x1 are at their default values which gives a periodic signal, and only slight deviation will change the properties of the signal a LOT.

The non-interpolated version gives the most 'harsh' signal.

It uses the equation x(n+2) = 1 - a * x(n+1)^2 + b * x(n)

freq = frequency
a = a
b = b
x0 = first value of x
x1 = second value of x
atk = attack
sus = sustain
rel = release
ts = timescale
out = channels out
pan = panning in stereo
amp = volume

Example:

(
~henon = Pdef(\henon,
    Pbind(
        \instrument, \henon,
        \scale, Scale.minor,
        \degree, Pseq([0,2,4,6,7], inf),
        \octave, [8,12,9,10],
        \dur, 0.25,
        \a, Pwhite(0, 1.55).round(0.05).trace,
        \b, Pwhite(0, 0.55).round(0.05).trace,
        \atk, 0,
        \sus, 0,
        \rel, Pexprand(0.01, 0.6),
        \amp, 1
    )
);
~henon.play.quant_(4, -1);
)

*/

(
SynthDef(\henon,{
    |a=1.3, b=0.3, amp=0.3, atk=0.01, freq=440, out=0, pan=0, rel=1, sus=1, ts=1, x0=0.30501993062401, x1=0.20938865431933|
		var sig,env;
		sig = HenonN.ar(freq,a,b,x0,x1,amp);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,ts,2);
		sig = LeakDC.ar(sig);
		sig = sig*env;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
);

/* VarGui Extension from miSCellaneous_lib quark

(

p = Pbind(
   \instrument, \henon,
   \scale, Scale.minor,
   \degree, Pseq([0,2,4,6,7].scramble, inf),
    \octave, Pseq([8, 10], inf),
   \dur, 0.25,
   \a, PL(\a),
   \b, PL(\b),
   \atk, 0,
   \rel, PL(\rel),
   \sus, 0,
   \amp, PL(\amp)
).play;

VarGui([
    //  [ minval, maxval, warp, step, default ]
    \a,   [0.01, 2.00, \lin, 0.01, 0.5],
    \b,   [0.01, 2.00, \lin, 0.01, 0.5],
    \amp, [0, 1, \lin, 0.001, 0.5],
    \rel, [0.01, 1, \lin, 0.001, 0.5]
], stream: p).gui;

);