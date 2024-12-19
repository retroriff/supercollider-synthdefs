/*
* https://www.patreon.com/posts/sc-808-available-40121526
*/

(
// Bass Drum
SynthDef.new(\bd, {
	arg decay = 16, amp = 1, gate = 0, out = 0, pan = 0, tone = 56;
	var fenv, env, trienv, sig, sub, punch, pfenv;
    // Xavi: Solution 1 to avoid multiples nodes
    // env = env * Env([1,1,0],[0.5,0.1]).kr(doneAction:2);
    // Xavi: Solution 2 to avoid multiples nodes
	env = EnvGen.kr(Env.new([0.11, 1, 0], [0, decay], -225), doneAction: 2);
	trienv = EnvGen.kr(Env.new([0.11, 0.6, 0], [0, decay], -230), doneAction: 0);
	fenv = Env([tone * 7, tone * 1.35, tone], [0.05, 0.6], -14).kr;
	pfenv = Env([tone * 7, tone * 1.35, tone], [0.03, 0.6], -10).kr;
	sig = SinOsc.ar(fenv, pi / 2) * env;
	sub = LFTri.ar(fenv, pi / 2) * trienv * 0.05;
	punch = SinOsc.ar(pfenv, pi / 2) * env * 2;
	punch = HPF.ar(punch, 350);
	sig = (sig + sub + punch) * 1.2 ;
	sig = Pan2.ar(sig, pan) * amp;
	Out.ar(out, sig);
}).add;

// Snare Drum
SynthDef.new(\sn, {
	arg amp = 1, tone = 340, tone2 = 189, snappy = 0.3, amp2 = 1, out = 0, pan=0;
	var noiseEnv, atkEnv, sig, noise, osc1, osc2, sum;
	noiseEnv = EnvGen.kr(Env.perc(0.001, 4.2, 1, -115), doneAction: 2);
	atkEnv = EnvGen.kr(Env.perc(0.001, 0.8, curve: -95), doneAction: 0);
    atkEnv = atkEnv * Env([1, 1, 0], [0.5, 0.1]).kr(doneAction: 2);
	noise = WhiteNoise.ar;
	noise = HPF.ar(noise, 1800);
	noise = LPF.ar(noise, 8850);
	noise = noise * noiseEnv * snappy;
	osc1 = SinOsc.ar(tone2, pi/2) * 0.6;
	osc2 = SinOsc.ar(tone, pi/2) * 0.7;
	sum = (osc1+osc2) * atkEnv * amp2;
	sig = Pan2.ar((noise + sum) * amp * 2.5, pan);
	sig = HPF.ar(sig, 340);
	Out.ar(out, sig);
}).add;

// Hand Clap
SynthDef.new(\cp, {
	arg amp = 1, gate = 0, out = 0, pan = 0;
	var atkenv, atk, decay, sum, denv;
	atkenv = EnvGen.kr(Env.new([0, 1,0], [0, 0.3], -160), doneAction:2);
	denv = EnvGen.kr(Env.dadsr(0.026, 0, 6, 0, 1, 1, curve:-157), doneAction:0);
	atk = WhiteNoise.ar * atkenv * 1.4;
	decay = WhiteNoise.ar * denv;
	sum = atk + decay * amp;
	sum = HPF.ar(sum, 500);
	sum = BPF.ar(sum, 1062, 0.5);
	Out.ar(out, Pan2.ar(sum, pan) * 4);
}).add;

// Low Tom
SynthDef.new(\lt, {
	arg amp = 1, freq = 80, out = 0, pan = 0;
	var sig, fenv, env, pnoise, penv;
	env = EnvGen.kr(Env.new([0.4, 1, 0], [0, 20], -250),doneAction:2);
	penv = EnvGen.kr(Env.new([0.6, 1, 0], [0, 30], -225),doneAction:2);
	fenv = Env([freq * 1.25, freq * 1.125, freq], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi / 2) * env;
	sig = Pan2.ar(sig * amp, pan);
	Out.ar(out, sig);
}).add;

// Mid Tom
SynthDef.new(\mt, {
	arg amp, freq=120, out = 0, pan=0;
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.4, 1, 0], [0, 16], -250),doneAction:2);
    // Xavi: Solution 1 to avoid multiples nodes
    env = env * Env([1,1,0],[0.5,0.1]).kr(doneAction:2);
	fenv = Env([freq*1.33333, freq*1.125, freq], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;

// High Tom
SynthDef.new(\ht, {
	arg amp, freq = 165, out = 0, pan=0;
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.4, 1, 0], [0, 11], -250),doneAction:2);
	fenv = Env([freq*1.333333, freq*1.121212, freq], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;

// Low Conga
SynthDef.new(\lc, {
	arg amp=1, freq=165, out = 0, pan=0;
	var sig, fenv, env, pnoise, penv;
	env = EnvGen.kr(Env.new([0.15, 1, 0], [0, 18], -250),doneAction:2);
    // Xavi: Solution 1 to avoid multiples nodes
    env = env * Env([1,1,0],[0.5,0.1]).kr(doneAction:2);
	penv = EnvGen.kr(Env.new([0.6, 1, 0], [0, 30], -225),doneAction:2);
	fenv = Env([freq*1.333333, freq*1.121212, freq], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2) * env;
	sig = Pan2.ar(sig * amp, pan);
	Out.ar(out, sig);
}).add;

// Mid Conga
SynthDef.new(\mc, {
	arg amp=1, freq=250, out = 0, pan=0;
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.15, 1, 0], [0, 9], -250),doneAction:2);
	fenv = Env([freq*1.24, freq*1.12, freq], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * amp, pan);
	Out.ar(out, sig);
}).add;

// High Conga
SynthDef.new(\hc, {
	arg amp=1, freq=370, out = 0;
	var sig, fenv, env;
	env = EnvGen.kr(Env.new([0.15, 1, 0], [0, 6], -250), doneAction:2);
	fenv = Env([freq*1.22972, freq*1.08108, freq], [0.1, 0.5], -4).kr;
	sig = SinOsc.ar(fenv, pi/2);
	sig = Pan2.ar(sig * env * amp * 0.9, 0);
	Out.ar(out, sig);
}).add;

// Rim Shot
SynthDef.new(\rs, {
	arg amp = 1, out = 0, pan = 0;
	var fenv, env, sig, punch, tri1, tri2;
	env = EnvGen.kr(Env.new([1, 1, 0], [0.00272, 0.07], -42), doneAction:2);
	tri1 = LFTri.ar(1667 * 1.1, 1) * env;
	tri2 = LFPulse.ar(455 * 1.1, width: 0.8) * env;
	punch = WhiteNoise.ar * env * 0.46;
	sig = tri1 + tri2 + punch;
	sig = BPeakEQ.ar(sig, 464, 0.44, 8);
	sig = HPF.ar(sig, 315);
	sig = LPF.ar(sig, 7300);
	sig = Pan2.ar(sig * amp, pan) * 0.3;
	Out.ar(out, sig);
}).add;

// Claves
SynthDef.new(\cl, {
	arg amp=1, out = 0, pan=0;
	var  env, sig;
	env = EnvGen.kr(Env.new([1, 1, 0], [0, 0.1], -20), doneAction:2);
	sig = SinOsc.ar(2500, pi/2) * env * amp;
	sig = Pan2.ar(sig, pan) * 0.3;
	Out.ar(out, sig);
}).add;

// Maracas
SynthDef.new(\ma, {
	arg amp = 1, out = 0, pan = 0;
	var env, sig;
	env = EnvGen.kr(Env.new([0.3, 1, 0], [0.027, 0.07], -250), doneAction: 2);
	sig = WhiteNoise.ar * env * amp;
	sig = HPF.ar(sig, 5500);
	sig = Pan2.ar(sig, pan) * 0.5;
	Out.ar(out, sig);
}).add;

// CowBell
SynthDef.new(\cb, {
	arg amp = 1, out = 0, pan = 0;
	var sig, pul1, pul2, env, atk, atkenv, datk;
	atkenv = EnvGen.kr(Env.perc(0, 1, 1, -215), doneAction: 0);
	env = EnvGen.kr(Env.perc(0.01, 9.5, 1, -90), doneAction: 2);
	pul1 = LFPulse.ar(811.16);
	pul2 = LFPulse.ar(538.75);
	atk = (pul1 + pul2) * atkenv * 6;
	datk = (pul1 + pul2) * env;
	sig = (atk + datk) * amp;
	sig = HPF.ar(sig, 250);
	sig = LPF.ar(sig, 4500) * 0.1;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;


SynthDef.new(\ch, {
	arg decay = 0.42, amp = 1, out = 0, pan = 0;
	var sig, sighi,siglow, sum, env, osc1, osc2, osc3, osc4, osc5, osc6;
	env = EnvGen.kr(Env.perc(0.005, decay, 1, -30), doneAction: 2);
	osc1 = LFPulse.ar(203.52);
	osc2 = LFPulse.ar(366.31);
	osc3 = LFPulse.ar(301.77);
	osc4 = LFPulse.ar(518.19);
	osc5 = LFPulse.ar(811.16);
	osc6 = LFPulse.ar(538.75);
	sighi = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    siglow = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    sighi = BPF.ar(sighi, 8900, 1);
    sighi = HPF.ar(sighi, 9000);
    siglow = BBandPass.ar(siglow, 8900, 0.8);
    siglow = BHiPass.ar(siglow, 9000, 0.3);
    sig = BPeakEQ.ar((siglow+sighi), 9700, 0.8, 0.7);
    sig = sig * env * amp;
    sig = Pan2.ar(sig, pan) * 0.4;
    Out.ar(out, sig);
}).add;


SynthDef.new(\oh, {
	arg decay = 0.5, amp = 1, out = 0, pan = 0;
	var sig, siga, sigb, env1, env2, osc1, osc2, osc3, osc4, osc5, osc6, sum;
	env1 = EnvGen.kr(Env.perc(0.1, decay, curve:-3), doneAction:2);
	env2 = EnvGen.kr(Env.new([0, 1, 0], [0, decay*5], curve:-150), doneAction:0);
	osc1 = LFPulse.ar(203.52) * 0.6;
	osc2 = LFPulse.ar(366.31) * 0.6;
	osc3 = LFPulse.ar(301.77) * 0.6;
	osc4 = LFPulse.ar(518.19) * 0.6;
	osc5 = LFPulse.ar(811.16) * 0.6;
	osc6 = LFPulse.ar(538.75) * 0.6;
	sig = osc1 + osc2 + osc3 + osc4 + osc5 + osc6;
	sig = BLowShelf.ar(sig, 990, 2, -3);
	sig = BPF.ar(sig, 7700);
	sig = BPeakEQ.ar(sig, 7200, 0.5, 5);
	sig = BHiPass4.ar(sig, 8100, 0.7);
	sig = BHiShelf.ar(sig, 9400, 1, 5);
	siga = sig * env1 * 0.6;
	sigb = sig * env2;
	sum = siga + sigb;
	sum = LPF.ar(sum, 4000);
	sum = Pan2.ar(sum, pan);
	sum = sum * amp * 1.5;
	Out.ar(out, sum);
}).add;

SynthDef.new(\cy, {
	arg decay = 2, amp = 1, out = 0, pan = 0, gate = 0, tone = 0.002;
	var sig, sig1,sig2, sig2a, sig2b, sig3, env1, env2, env2b, env3, osc1, osc2, osc3, osc4, osc5, osc6, sum;
	env1 = EnvGen.kr(Env.perc(0.3, decay, curve:-3), doneAction:2);
	env2 = EnvGen.kr(Env.new([0, 0.6, 0], [0.1, decay*0.7], curve: -5), doneAction:0);
	env2b = EnvGen.kr(Env.new([0, 0.3, 0], [0.1, decay*20], curve: -120), doneAction:0);
	env3 = EnvGen.kr(Env.new([0, 1, 0], [0, decay*5], curve: -150), doneAction:0);
	osc1 = LFPulse.ar(203.52);
	osc2 = LFPulse.ar(366.31);
	osc3 = LFPulse.ar(301.77);
	osc4 = LFPulse.ar(518.19);
	osc5 = LFPulse.ar(811.16);
	osc6 = LFPulse.ar(538.75);
	sig = osc1 + osc2 + osc3 + osc4 + osc5 +osc6;
	sig1 = BLowShelf.ar(sig, 2000, 1, 5);
	sig1 = BPF.ar(sig1, 3000);
	sig1 = BPeakEQ.ar(sig1, 2400, 0.5, 5);
	sig1 = BHiPass.ar(sig1, 1550, 0.7);
	sig1 = LPF.ar(sig1, 3000);
	sig1 = BLowShelf.ar(sig1, 1000, 1, 0);
	sig1 = sig1 * env1 * tone;
	sig2 = BLowShelf.ar(sig, 990, 2, -5);
	sig2 = BPF.ar(sig2, 7400);
	sig2 = BPeakEQ.ar(sig2, 7200, 0.5, 5);
	sig2 = BHiPass4.ar(sig2, 6800, 0.7);
	sig2 = BHiShelf.ar(sig2, 10000, 1, -4);
	sig2a = sig2 * env2 * 0.3;
	sig2b = sig2 * env2b * 0.6;
	sig3 = BLowShelf.ar(sig, 990, 2, -15);
	sig3 = BPF.ar(sig3, 6500);
	sig3 = BPeakEQ.ar(sig3, 7400, 0.35, 10);
	sig3 = BHiPass4.ar(sig3, 10500, 0.8, 2);
	sig3 = sig3 * env3;
	sum = sig1 + sig2a + sig2b + sig3;
	sum = LPF.ar(sum, 4000);
	sum = Pan2.ar(sum, pan);
	sum = sum * amp * 3;
	Out.ar(out, sum);
}).add;

)
