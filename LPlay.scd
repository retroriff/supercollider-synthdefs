/*
It needs to be reevaluated to get the new tempo.
*/

(
// 1. Plays a stereo file
SynthDef(\lplay,{
	|amp = 1, atk = 0.01, beats = 0, buf = 0, decay = 0.3, dur = 4, gate = 1,
    out = 0, pan = 0, rel = 0.05, rate = 1, start = 0, sus = 1, tempo|

    var env, sig;
    var frames = BufFrames.kr(buf);
    var isRewind = (rate < 0);
    var startPos = abs((frames * isRewind) - (frames * start)) - (2 * isRewind);

    // Rate & tempo
	beats = Select.kr(beats, [dur, beats]);
    tempo = Select.kr(tempo, [TempoClock.default.tempo, tempo]);
    rate = ((BufFrames.ir(buf) / s.sampleRate) * tempo / beats);
    rate = Select.kr(isRewind, [rate, rate.neg]);

    // Sustain
	dur = Select.kr((dur < beats), [1, dur / beats]);
    sus = (BufDur.kr(buf) * dur / rate.abs) * sus;

    env = EnvGen.ar(
        Env.linen(atk, sus, rel),
        gate,
        doneAction: 2
    );

    sig = Mix.ar(
        PlayBuf.ar(
            numChannels: 2,
            bufnum: buf,
            rate: rate,
            startPos: startPos,
            loop: 0,
            doneAction: 2
        );
    );

    sig = (sig * env) * amp;
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

     // Debug http://danielnouri.org/docs/SuperColliderHelp/Language/Debugging-tips.html
    // o = OSCresponderNode(s.addr, '/tr', { |time, resp, msg| msg.postln }).add;
    // SendTrig.kr(in:Impulse.kr(4), id:rate, value:startPos);
    // New debug: Add .poll. Example: startPos.poll(label: \StartPos);

    sig = Mix.ar(PlayBuf.ar(numChannels: 1, bufnum: buf, rate: rate, trigger: 1, startPos: startPos, loop: 0, doneAction: 2));
	env = EnvGen.ar(Env.linen(attackTime: atk, sustainTime: sus, releaseTime: rel), gate: 1, doneAction: 2);
	sig = sig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;
)
