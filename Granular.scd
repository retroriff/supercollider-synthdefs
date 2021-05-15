/************************************
Granular Synthesis Demo (GUI)
Patch 1 - Granular Sampling
Bruno Ruviaro, 2013-08-20
************************************

The buffer must be MONO, or Buffer should read only 1 channel:
buffer = Buffer.readChannel(s, path, channels: [0]);
Pattern is executed 1 time, otherwise the server is overload.
To clear and specific node: s.sendMsg("/n_free", nodeID);
*/

(
SynthDef(\granular, {
	arg triggerLo, triggerHi, rateLo, rateHi, centerPosLo, centerPosHi, durLo, durHi,
	panLo, panHi, ampLo, ampHi, reverseProb, bufnum;

	var trig, trigFreqMess, rate, centerPos, dur, pan, amp, coin, reverse, sig;
	// var bufdur = BufDur.kr(buffer);

	trigFreqMess = LFNoise2.kr(12).range(0.5, 1);
	trig = Impulse.kr(LFNoise0.kr(trigFreqMess).range(triggerLo, triggerHi));

	rate = Dwhite(rateLo, rateHi);
	centerPos = Dwhite(centerPosLo, centerPosHi);
	dur = Dwhite(durLo, durHi);
	pan = Dwhite(panLo, panHi);
	amp = Dwhite(ampLo, ampHi);
	coin = CoinGate.kr(reverseProb, trig);
	reverse = Select.kr(coin, [1, -1]);
	// reverse.poll(trig);

	Demand.kr(trig, 0, [rate, centerPos, dur, pan, amp]);

	sig = TGrains.ar(
		numChannels: 2,
		trigger: trig,
		bufnum: bufnum,
		rate: rate * reverse,
		centerPos: centerPos,
		dur: dur,
		pan: pan,
		amp: amp);

	Out.ar(0, sig);
}).add;

/**
https://medium.com/@hinea/diy-granular-synthesis-in-supercollider-e2f5d3d6b23a
*/

SynthDef(\granular2, { |amp, buf|
    var outBus = 0;
    var susLevel = 0.6;
    var releaseTime = LFNoise0.kr(400, 5, 8);
    var startPos = LFNoise2.kr(5000, 1, 0.0) * BufFrames.kr(buf);
    var gate = Line.kr(1, 0, 0.005);
    var vol = Linen.kr(gate, 0.05, susLevel, releaseTime, 2);
    var playBuf = PlayBuf.ar(2, buf, 1, 1, startPos: startPos, doneAction: 2);
    Out.ar(outBus, playBuf * amp * vol);
}).add;


/**
* @author: Eli Fieldsteel
* @url: https://github.com/elifieldsteel/SuperCollider-Tutorials/blob/master/full%20video%20scripts/25_script.scd
*/
SynthDef.new(\gs, {
    |sync=1, dens=20, baseDur=0.1, durRand=1, buf=0, rate=1,
    pos=0, posSpeed=1, posRand=0, grainEnv=(-1), pan=0, panHz=0.1, panRand=0,
    atk=1, sus=2, rel=1, c0=1, c1=(-1), amp=1, out=0|

    var sig, env, densCtrl, durCtrl, posCtrl, panCtrl;
    env = EnvGen.ar(Env.new([0,1,1,0], [atk,sus,rel], [c0,0,c1]), doneAction:2);

    densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);

    durCtrl = baseDur * LFNoise1.kr(100).exprange(1/durRand,durRand);

    posCtrl = Phasor.ar(0, posSpeed * BufRateScale.ir(buf), 0, BufSamples.ir(buf));
    posCtrl = posCtrl + LFNoise1.kr(100).bipolar(posRand*SampleRate.ir);
    posCtrl = posCtrl / BufSamples.ir(buf);
    posCtrl = posCtrl + pos;

    panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

    sig = GrainBuf.ar(
        2,
        densCtrl,
        durCtrl,
        buf,
        rate,
        posCtrl,
        2,
        panCtrl,
        grainEnv
    );

    sig = sig * env * amp;

    Out.ar(out, sig);
}).add;
)

/*(
Synth.new(\gs,[
    \buf, b,
	\sync, 1,
	\amp, 0.5,
	\dens, 10,
	\dur, 0.09,
	\posSpeed, 0,
	\pos, 0.3,
	\sus, 5
])
)*/

// (
// b = Buffer.readChannel(s, "/Users/xavi/Dropbox/Music/Samples/Live Coding/voice/BorbonesLadrones.aiff", channels:[0]);

/*Pdef(\t, Pbind(
	\instrument, \gs,
    \buf, b,
	\sync, 1,
	\amp, 0.5,
	\dens, 10,
	\dur, 0.09,
	\baseDur, Pkey(\dur),
	\posSpeed, 0,
	\pos, 0.2
)).play.quant_(4);
)*/


/*
Example 1: MONO

b = Buffer.readChannel(s, d["rave"][0].path, channels: [0]);
s.plotTree
s.queryAllNodes;
s.sendMsg("/n_free", 4060);

(
Pdef(\granular, Pbind(\instrument, \granular, \amp, 0.5, \buf, b,
    \triggerLo, 0, // 0.5 to 50
	\triggerHi, 5, // 0.5 to 50
	\rateLo, 14, // -24 to 24
	\rateHi, 0, // -24 to 24
	\centerPosLo, 0, // 0 to 1?
	\centerPosHi, 1, // 0 to 1?
	\durLo, 0.1, // 0.1 to 2
	\durHi, 0.1, // 0.1 to 2
	\panLo, 1, // -1 to 1
	\panHi, 1, // -1 to 1
	\ampLo, 1, // 0 to 1
	\ampHi, 1, // 0 to 1
	\reverseProb, 0, // 0 to 100
	\bufnum, b,
    \dur, Pseq([4], 1)
)).play.quant_(4);
)


(
r = Synth(\granular, [
    \triggerLo, 0, // 0.5 to 50
	\triggerHi, 5, // 0.5 to 50
	\rateLo, 14, // -24 to 24
	\rateHi, 5, // -24 to 24
	\centerPosLo, 10, // 0 to 1?
	\centerPosHi, 1, // 0 to 1?
	\durLo, 0.1, // 0.1 to 2
	\durHi, 0.1, // 0.1 to 2
	\panLo, 1, // -1 to 1
	\panHi, 1, // -1 to 1
	\ampLo, 1, // 0 to 1
	\ampHi, 1, // 0 to 1
	\reverseProb, 0, // 0 to 100
	\bufnum, b,
]);
)*/

/*
Example 2: Stereo

(
Pdef(\granular2, Pbind(
    \instrument, \granular2,
    \amp, 0.3,
	\buf, ~s.("games", 4),
    \dur, Pxrand([10, 20, 30, 50, 80, 90, 120, 140, 150, 180, 200]/2000, inf)
)).play.quant_(4);
)

Pdef(\loop, Pbind(\instrument, \lplay, \buf, ~s.("games", 2), \dur, 1/2, \start, 1/Pwhite(1, 8), \beats, 4, \amp, 1)).play.quant_(4);
*)

