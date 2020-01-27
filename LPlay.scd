(

SynthDef(\lplay,{
    |amp=0.5, buf=0, dur=4, out=0, pan=0, rate=1, rel=15|
	var env, frames, isForward, sig, startPos;

    frames = BufFrames.kr(buf);
    isForward = (rate < 0);
    startPos = abs( (frames * isForward) - (frames * 0) ) - (2 * isForward);
    rate = ((BufFrames.ir(buf) / s.sampleRate) * TempoClock.default.tempo / dur) * rate;

	sig = Mix.ar(PlayBuf.ar(2, buf, rate, 1, 0, startPos:startPos, doneAction:2));
	env = EnvGen.ar(Env.linen(0.0, rel, 0), doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

)
