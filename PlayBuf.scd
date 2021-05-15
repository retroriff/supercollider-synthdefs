// 1. Plays a stereo file
(
SynthDef(\playbuf, {
    |amp=1, atk=0.01, buf=0, dur=1, out=0, pan=0, rel=0.05, rate=1, start=0, sus=1|
	var beatDur, env, frames, isRewind, numChannels=2, startPos, sig;

    isRewind = (rate < 0);
    frames = BufFrames.kr(buf);
    startPos = abs( (frames * isRewind) - (frames * start) ) - (2 * isRewind);

    rate = BufRateScale.ir(buf) * rate;

	sus = (BufDur.kr(buf) * sus);
    beatDur = TempoClock.beatDur;
    sus = Select.kr(((beatDur * dur) > sus), [beatDur * dur, sus]); // Conditional to avoid that sample length is longer than a pattern

	// https://supercollider.github.io/tutorials/If-statements-in-a-SynthDef.html
	// Conditional: Select.kr(condition > 1, false, true);
	// numChannels = Select.kr((buf < 1), [BufChannels.ir(buf), 2]);
	// Frames to Seconds
	// sus = (frames / s.sampleRate) * sus;

	// Old Debug: http://danielnouri.org/docs/SuperColliderHelp/Language/Debugging-tips.html
    // o = OSCresponderNode(s.addr, '/tr', { |time, resp, msg| msg.postln }).add;
    // SendTrig.kr(Impulse.kr(4), 0, sus);
    // New debug: Add .poll
    // dur.poll(label: \dur);

    // ToDo: Playbuf.ar(buf.numChannels) But buf.numChannels always returns 1
    // buf = NumChannels.ar(buf, numChannels: 2, mixdown: true);
    // BufChannels.kr(buf).poll(label: \numChannels);

	numChannels = Select.kr(BufChannels.kr(buf) > 1, 2, 1); // Conditional

    sig = Mix.ar(PlayBuf.ar(numChannels: 2, bufnum: buf, rate: rate, trigger: 1, startPos: startPos, loop: 0, doneAction: 2));
	env = EnvGen.ar(Env.linen(attackTime: atk, sustainTime: sus, releaseTime: rel), gate: 1, doneAction: 2);
	sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;

// 2. Plays a mono file

SynthDef(\playbufMono, {
    |amp=1, atk=0.01, buf=0,  out=0, pan=0, rel=0.05, rate=1, start=0, sus=1|
    var env, frames, isRewind, startPos, sig;

    isRewind = (rate < 0);
    frames = BufFrames.kr(buf);
    startPos = abs( (frames * isRewind) - (frames * start) ) - (2 * isRewind);

    rate = BufRateScale.ir(buf) * rate;

	sus = (BufDur.kr(buf) * sus);

    sig = Mix.ar(PlayBuf.ar(numChannels: 1, bufnum: buf, rate: rate, trigger: 1, startPos: startPos, loop: 0, doneAction: 2));
	env = EnvGen.ar(Env.linen(attackTime: atk, sustainTime: sus, releaseTime: rel), gate: 1, doneAction: 2);
	sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;
);

/*
Example:
Pdef(\loop, Pbind(\instrument, \playbuf, \buf, d["fm"][2], \dur, 2, \amp, 0.4, \rate, 1, \sus, 1)).play.quant_(4, -1);
*/

/*
Backup: 17/02/2020
Plays a file
(
SynthDef(\playbuf, {
    |amp=1, atk=0.01, buf=0, out=0, pan=0, pos=0, rel=0.05, rate=1, sus=1|
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
*/