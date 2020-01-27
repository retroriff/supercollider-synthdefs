// Plays a file
(
SynthDef(\playbuf, {
    |amp=0.5, atk=0.01, buf=0, out=0, pan=0, pos=0, rel=0.05, rate=1, sus=1|
    var env, frames, isRewind, startpos, sig;
    isRewind = (rate < 0);
    frames = BufFrames.kr(buf);
    startpos = abs( (frames * isRewind) - (frames * pos) ) - (2 * isRewind);
    sig = Mix.ar(PlayBuf.ar(2,buf, BufRateScale.ir(buf) * rate, 1, startPos:startpos, doneAction:2));
    //env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: Done.freeSelf);
	env = EnvGen.ar(Env.linen(atk, sus, rel, 1), doneAction:2);
	sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;
);
