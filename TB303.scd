/**
* Roland TB-303
* @author: https://sccode.org/1-4Wy
*/

(
SynthDef (\tb303, {
    |amp = 0.5, ctf = 0.1, dec = 1.0, env = 1000, freq = 440,
    gate = 1, out = 0, res = 0.2, sus = 0, wave = 0|

    var getValue = { |initialValue, minValue, maxValue|
        minValue + (initialValue.clip(0, 1) * (maxValue - minValue));
    };

    var decay = getValue.(dec, 1, 5);

    var volEnv = EnvGen.ar(
        Env.new(
            levels: [10e-10, 1, 1, 10e-10],
            times: [0.01, sus, dec],
            curve: 'exp'),
        gate,
        doneAction: Done.freeSelf
    );

    var filEnv = EnvGen.ar(
        Env.new(
            levels: [10e-10, 1, 10e-10],
            times: [0.01, dec],
            curve: 'exp' ),
        gate,
        doneAction: Done.freeSelf
    );

    var waves = [Saw.ar(freq, mul: volEnv), Pulse.ar(freq, width: 0.5, mul: volEnv)];

    var ctfFreq = getValue.(ctf, 100, 10000);

    var sig = RLPF.ar(
        in: Select.ar(wave, waves),
        freq: ctfFreq.value + (filEnv * env),
        rq: res
    ).dup;

    Out.ar(out, sig * amp);
}).add;
)

/*
(
~insomnia = Pseq([0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 12] + 36, inf).midicps;
Pdef(\tb303, Pbind(
    \instrument, \303,
    \dur, Pseq([0.25], inf),
    \freq, ~insomnia,
    \amp, 0.3,
    \ctf, 0.1,
    \dec, 2,
    \env, 50,
    \wave, 0
)).play.quant_(4, -1);
)

303 freq: \rand cf: 1 env: 1 \wave: 0
909 i: \bd
909 i: \sn dur: 2 off: 1
909 i: \oh off: 0.5 amp: 0.3

1 play: ["fm"] degree: \rand length: 3 amp: 0.3

Px.shuffle

~octave1 = Pseq([ 0, 12, 0, 0, -12, 0, 0, 0, -12, 0, 12, 0, 0, 0, 0, 0 ] + 36, inf).midicps;
~randomSeed = Pseq([Pseed(1002, Pwrand([0, 12, -12], [8, 1, 1].normalizeSum, 16))] + 36, inf).midicps;
~random = Pseq([Pseed(Pstutter(16, Pwhite(1, 1000).trace), Pwrand([1, 9, -3], [9, 3, 3].normalizeSum, 16))] + 36, inf).midicps;
~insomnia = Pseq([ 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 12 ] + 36, inf).midicps;

(
a = { |value|
    50 + (value * (10000 - 50));
};

a.(10000);
)
/* Example

Ctf:  50 - 10000
Env:  0 - 10000
Res:  0 - 1
Dec:  0.3 - 2
Wave: 0 (Saw) or 1 (Pulse)
*/

(
Pdef(\303, Pbind(
\instrument, \303,
\dur, Pseq([0.25], inf),
\freq, Pseq([ 0, 12, 0, 0, -12, 0, 0, 0, -12, 0, 12, 0, 0, 0, 0, 0 ] + 36, inf).midicps,
\freq, Pseq([Pseed(1003, Pwrand([1, 12, -12], [8, 1, 1].normalizeSum, 16))] + 36, inf).midicps,
\freq, Pseq([Pseed(Pstutter(16, Pwhite(1,1000).trace), Pwrand([1, 9, -3], [9, 3, 3].normalizeSum, 16))] + 36, inf).midicps,
\amp, 0.5,
\ctf, 100,
\dec, 1,
\env, 1000,
\wave, 0
)).play.quant_(4, -1);
)
Pdef(\303, Pbind(\i, \303, \a, 1, \dur, 0.75, \freq, 440/8, \ctf, 1800, \env, 3000)).play.quant_(4, -1);

*/