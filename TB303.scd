/**
* Roland TB-303
* @author: https://sccode.org/1-4Wy
*/

(
 SynthDef (\tb303, {
    |amp=0.5, ctf=100, dec=1.0, env=1000, freq=440, gate=1, out=0, res=0.2, sus=0, wave=0 |
	var filEnv, sig, volEnv, waves;

	volEnv =  EnvGen.ar( Env.new([10e-10, 1, 1, 10e-10], [0.01, sus, dec],  'exp' ), gate, doneAction: Done.freeSelf);
	filEnv =  EnvGen.ar( Env.new([10e-10, 1, 10e-10], [0.01, dec],  'exp' ), gate, doneAction: Done.freeSelf);
	waves = [ Saw .ar(freq, volEnv),  Pulse .ar(freq, 0.5, volEnv)];

    sig = RLPF.ar( Select.ar(wave, waves), ctf + (filEnv * env), res).dup;
    sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

/*~octave1 = Pseq([ 0, 12, 0, 0, -12, 0, 0, 0, -12, 0, 12, 0, 0, 0, 0, 0 ] + 36, inf).midicps;
~randomSeed = Pseq([Pseed(1002, Pwrand([0, 12, -12], [8, 1, 1].normalizeSum, 16))] + 36, inf).midicps;
~random = Pseq([Pseed(Pstutter(16, Pwhite(1, 1000).trace), Pwrand([1, 9, -3], [9, 3, 3].normalizeSum, 16))] + 36, inf).midicps;
~insomnia = Pseq([ 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 12 ] + 36, inf).midicps;
~insomnia = Pseq([ 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 0, 12, 12 ] + 36, inf).midicps;

(
~chain = Ptpar([
    0, Pbind(\i, \bd, \a, 1, \dur, 1),
    1, Pbind(\i, \sn, \a, 1, \dur, 2),
    0.5, Pbind(\i, \cymbal, \a, 1, \dur, 1),
    0, Pbind( \i, \tb303, \a, 0.3, \dur, Pseq([0.25], inf), \freq, ~insomnia, \ctf, 10000, \dec, 1, \env, 1000, \wave, 0)
]);
Pdef(\o, ~chain).play.quant_(4).fadeTime_(0);
)

(
Pdef(\tb303, Pbind(
    \instrument, \tb303,
	\dur, Pseq([0.25], inf),
	\freq, ~insomnia,
	\amp, 0.3,
	\ctf, 10000,
	\dec, 1,
	\env, 1000,
	\wave, 0
)).play.quant_(4, -1);
)*/


/* Example

Ctf:  50 - 10000
Env:  0 - 10000
Res:  0 - 1
Dec:  0.3 - 2
Wave: 0 (Saw) or 1 (Pulse)

Pdef(\tb303, Pbind(
    \instrument, \tb303,
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

Pdef(\303, Pbind(\i, \tb303, \a, 1, \dur, 0.75, \freq, 440/8, \ctf, 1800, \env, 3000)).play.quant_(4, -1);

*/