(

/*
If rate argument is not received, it calculates the rate but the tempo can't be changed.
The Synthdef needs to be reevaluated to get the new tempo.
In order to get the right tempo, we must calculate the rate previously and pass it to the Synthdef:

(
~loopTrack = ~s.("break8", 5);
~loopDur = 8;
~loopRate = Pfunc { ((~loopTrack.numFrames / s.sampleRate) * (~bpm/60) / ~loopDur) };
Pdef(\loopTempo, Pbind(\instrument, \lplay, \buf, ~loopTrack, \dur, ~loopDur, \amp, 0.2, \rate, ~loopRate)).play.quant_(4, -1);
)

*/

// 1. Plays a stereo file
SynthDef(\lplay,{
	|amp=0.5, atk = 0.01, beats=0, buf=0, dur=4, out=0, pan=0, rel=0.05, rate=1, start=0, sus=1, tempo|
	var env, frames, isRewind, missingTempo, sig, startPos;

    // Forward / Rewind
    isRewind = (rate < 0);
    frames = BufFrames.kr(buf);
    startPos = abs( (frames * isRewind) - (frames * start) ) - (2 * isRewind);
    // startPos.poll(label: \StartPos);

	beats = Select.kr((beats > 0), [dur, beats]); // Conditional
    tempo = Select.kr((tempo > 0), [TempoClock.default.tempo, tempo]); // Conditional
    rate = ((BufFrames.ir(buf) / s.sampleRate) * tempo / beats);
    rate = Select.kr((isRewind < 1), [rate.neg, rate]); // Conditional
    // rate = Select.kr((rate > 0) + (rate < 0), [missingTempo, rate]); // Conditional

	beats = Select.kr((dur < beats), [1, dur/beats]); // Conditional
    sus = (BufDur.kr(buf) * sus / rate.abs) * beats;

	// Debug http://danielnouri.org/docs/SuperColliderHelp/Language/Debugging-tips.html
    // o = OSCresponderNode(s.addr, '/tr', { |time, resp, msg| msg.postln }).add;
    // SendTrig.kr(in:Impulse.kr(4), id:rate, value:startPos);
    // New debug: Add .poll. Example: startPos.poll(label: \StartPos);

    sig = Mix.ar(PlayBuf.ar(numChannels: 2, bufnum: buf, rate: rate, trigger: 1, startPos: startPos, loop: 0, doneAction: 2));
	env = EnvGen.ar(Env.linen(attackTime: atk, sustainTime: sus, releaseTime: rel), gate: 1, doneAction: 2);
	sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;


// 2. Plays a mono file
SynthDef(\lplaym,{
	|amp=0.5, atk = 0.01, beats=0, buf=0, dur=4, out=0, pan=0, rel=0.05, rate=1, start=0, sus=1, tempo|
	var env, frames, isRewind, missingTempo, sig, startPos;

    // Forward / Rewind
    isRewind = (rate < 0);
    frames = BufFrames.kr(buf);
    startPos = abs( (frames * isRewind) - (frames * start) ) - (2 * isRewind);

	beats = Select.kr((beats > 0), [dur, beats]); // Conditional
    tempo = Select.kr((tempo > 0), [TempoClock.default.tempo, tempo]); // Conditional
    rate = ((BufFrames.ir(buf) / s.sampleRate) * tempo / beats);
    rate = Select.kr((isRewind < 1), [rate.neg, rate]); // Conditional

	beats = Select.kr((dur < beats), [1, dur/beats]); // Conditional
    sus = (BufDur.kr(buf) * sus / rate.abs) * beats;

    sig = Mix.ar(PlayBuf.ar(numChannels: 1, bufnum: buf, rate: rate, trigger: 1, startPos: startPos, loop: 0, doneAction: 2));
	env = EnvGen.ar(Env.linen(attackTime: atk, sustainTime: sus, releaseTime: rel), gate: 1, doneAction: 2);
	sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;

)

/*
Example 1: Tempo doesn't need to be passed when the track will be played in a single tempo all the time
Pdef(\loop, Pbind(\instrument, \lplay, \buf, ~s.("break4", 2), \dur, 4, \amp, 0.5)).play.quant_(4);
Example 2: Tempo must be passed when the track will have different tempos
Pdef(\loopTempo, Pbind(\instrument, \lplay, \buf, ~loopTrack, \dur, ~loopDur, \amp, 0.5, \rate, -1, \tempo, Pfunc({~bpm/60}))).play.quant_(4);
*/

/*
Old Snippet: Calculate the rate outside of SynthDef 17/07/2020
~loopTrack = ~s.("break4", 2);
~loopDur = 4;
~loopRate = Pfunc { ((~loopTrack.numFrames / s.sampleRate) * (~bpm/60) / ~loopDur) };
~loopTempo = ~bpm/60;
*/

/* Backup: 17/02/2020
SynthDef(\lplay,{
	|amp=0.5, buf=0, dur=4, out=0, pan=0, rate, rel=15|1
	var env, frames, isRewind, missingRate, sig, startPos;

    frames = BufFrames.kr(buf);
    isRewind = (rate < 0);
    startPos = abs( (frames * isRewind) - (frames * 0) ) - (2 * isRewind);

    missingRate = ((BufFrames.ir(buf) / s.sampleRate) * TempoClock.default.tempo / dur);
    rate = Select.kr((rate > 0) + (rate < 0), [missingRate, rate]);

	sig = Mix.ar(PlayBuf.ar(2, buf, rate, 1, 0, startPos:startPos, doneAction:2));
	env = EnvGen.ar(Env.linen(0.0, rel, 0), doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

*/


/*
This one needs the rate argument, which is calculated by Pfunc.
Pfunc { ((d["break4"][0].numFrames / s.sampleRate) * (~bpm/60) / 4); }

(
~loop = Pdef(\loop, Pbind(\instrument, \lplayTempo, \buf, d["break4"][0], \dur, 4, \amp, 0.1,
	\rate, Pfunc { ((d["break4"][0].numFrames / s.sampleRate) * (~bpm/60) / 4); }.trace
)).play.quant_(4, -1);
)

SynthDef(\lplayTempo,{
    |amp=0.5, buf=0, dur=4, out=0, pan=0, rate=1, rel=15|
	var env, frames, isForward, sig, startPos;

    frames = BufFrames.kr(buf);
    isForward = (rate < 0);
    startPos = abs( (frames * isForward) - (frames * 0) ) - (2 * isForward);

	sig = Mix.ar(PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, 1, 0, startPos:startPos, doneAction:2));
	env = EnvGen.ar(Env.linen(0.0, rel, 0), doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

*/