(

/*
https://truthindustri.es/supercollider/2019/01/05/supercollider-track.html
*/

SynthDef("pad", {
    |amp = 0.5, gate = 1, midinote = 40, out = 0|
    var ampEnv, freq, gen, fmod, rqmod, snd;

    ampEnv = EnvGen.ar(envelope: Env.adsr(3, 0.3, 2, 5, 0.5), gate: gate, doneAction: 2) * 3;
    freq = { midinote.midicps * LFNoise2.kr(1,0.01,1) }!12;
    gen = LFSaw.ar(freq: freq, mul: ampEnv);
    fmod = LFCub.kr(1/12, mul: ampEnv).range(1, MouseX.kr(2,16));
    rqmod = LFNoise2.kr(1/8, mul: ampEnv).range(0.1,1.0);
    snd = RLPF.ar(gen, freq * fmod, rqmod, ampEnv);
    Out.ar(out, Splay.ar(snd * ampEnv * amp));
}).add;
)


