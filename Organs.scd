(
/*
* organ_tonewheel0: Additive tonewheel organ with few CPU usage
* By Zé Craum
*/
SynthDef(\organ, {
	arg freq = 440, amp = 0.7, atk = 0.001, sus = 0.2, rel = 0.01, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, out = 0, nazard = 1, blockFlute = 1,
	tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
    vrate = 3, vdepth = 0.008; //vibrato arguments
	var sig, env, vibrato;

	vibrato = SinOsc.kr(DC.kr(vrate)).range(1 - DC.kr(vdepth), 1+ DC.kr(vdepth));
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio,
		([DC.ar(bass), DC.ar(quint), DC.ar(fundamental), DC.ar(oct),
			DC.ar(nazard), DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot),
			DC.ar(sifflute)].normalizeSum), nil], vibrato * freq);
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;

// organ_tonewheel1: Additive tonewheel organ with more CPU usage
// By Zé Craum
SynthDef(\organ1, {
	arg freq = 440, amp = 0.7, atk = 0.001, sus = 0.2, rel = 0.01, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, nazard = 1, blockFlute = 1,
	tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
    vrate = 3, vdepth = 0.008, vdelay = 0.1, vonset = 0, vrateVariation = 0.1,
	vdepthVariation = 0.1; //vibrato arguments
	var sig, env, vibrato;

	vibrato = Vibrato.kr(DC.kr(freq), DC.kr(vrate), DC.kr(vdepth), DC.kr(vdelay),
		DC.kr(vonset), DC.kr(vrateVariation), DC.kr(vdepthVariation));
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio,
		([DC.ar(bass) , DC.ar(quint), DC.ar(fundamental), DC.ar(oct), DC.ar(nazard),
			DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot),
			DC.ar(sifflute)].normalizeSum), nil], vibrato);
	sig = sig * env;
	Out.ar(0, Pan2.ar(sig, pan, amp));
}).add;


// organ_tonewheel2: Subtractive tonewheel organ with cheap CPU usage
// By Zé Craum
SynthDef(\organ2, {
	arg freq = 440, amp = 0.7, atk = 0.001, sus = 0.4, rel = 0.1, tune = 0.29, tuneRate = 6.0, rq = 1;
	var sig, env, vibrato;
	env = EnvGen.ar(Env.linen(atk, sus, rel, 0.5), doneAction: Done.freeSelf);
	vibrato = SinOsc.ar(tuneRate).range(freq, freq * (tune.midiratio));
	sig = LFPulse.ar(freq, 0, 0.5, 0.2) + LFPulse.ar(freq + vibrato, 0, 0.18);
	sig = RLPF.ar(sig /*+ PinkNoise.ar(20/freq) */, ((28.midiratio) * (freq)) , rq) ;

	sig = sig * env;
	sig = sig * amp;
	sig = LeakDC.ar(sig);
	Out.ar(0, sig!2);
}).add;


// organ_tonewheel3: Subtractive tonewheel organ with more CPU usage
//By Zé Craum
SynthDef(\organ3, {
	arg freq = 440, amp = 0.9, atk = 0.001, sus = 0.4, rel = 0.1, vrate = 6, vdepth = 0.02, vdelay = 0.1, vonset = 0, vrateVariation = 0.1, vdepthVariation = 0.1, rq =1;
	var sig, env, vibrato;
	env = EnvGen.ar(Env.linen(atk, sus, rel, 0.5), doneAction: Done.freeSelf);
	vibrato = Vibrato.kr(DC.kr(freq), DC.kr(vrate), DC.kr(vdepth), DC.kr(vdelay), DC.kr(vonset), DC.kr(vrateVariation), DC.kr(vdepthVariation));
	sig = LFPulse.ar(freq, 0, 0.5, 0.2) + LFPulse.ar(freq + vibrato, 0, 0.18);
	sig = BLowPass4.ar(sig, ((28.midiratio) * (freq)) , rq) ;

	sig = sig * env;
	sig = sig * (amp * 1.5);
	sig = LeakDC.ar(sig);
	Out.ar(0, sig!2);
}).add;


// organ_tonewheel4: Subtractive tonewheel organ from Steal this Sound example
// By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
// http://www.sussex.ac.uk/Users/nc81/index.html
SynthDef(\organ4,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 4.85 lfowidth= 0.1 cutoff= 5000 rq=0.25 pan = 0.0|
	var lfo, pulse, filter, env;

	lfo = LFTri.kr(lforate*[1,1.01],Rand(0,2.0)!2);

	pulse = Pulse.ar( (((freq*[1,3]).cpsmidi) + (lfo*lfowidth)).midicps,[0.5,0.51],[0.4,0.6]);

	env = EnvGen.ar(Env.adsr(0.0,0.0,1.0,0.1),gate,doneAction:2);

	filter = BLowPass4.ar(pulse,cutoff,rq);

	filter= BPeakEQ.ar(filter,500,1.0,3);

	Out.ar(out,Pan2.ar(Mix(filter)*env*amp,pan));
}).add;


// organ_donor: Simulation of transistor organ from Steal This Sound
// By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
// http://www.sussex.ac.uk/Users/nc81/index.html
SynthDef(\organ_donor,{|out= 0 freq = 440 amp = 0.2 gate=1 lforate = 10 lfowidth= 0.0 cutoff= 100 rq=0.5 pan=0.0|
	var vibrato, pulse, filter, env;

	vibrato = SinOsc.ar(lforate,Rand(0,2.0));

	//up octave, detune by 4 cents
	//11.96.midiratio = 1.9953843530485
	//up octave and a half, detune up by 10 cents
	//19.10.midiratio = 3.0139733629359

	//Pulse version
	//pulse = Mix(Pulse.ar(([1,1.9953843530485,3.0139733629359]*freq)*(1.0+(lfowidth*vibrato)),Rand(0.4,0.6)!3,[1.0,0.7,0.3]))*0.5;

	//better alternative
	pulse = Mix(VarSaw.ar(([1,1.9953843530485,3.0139733629359]*freq)*(1.0+(lfowidth*vibrato)),Rand(0.0,1.0)!3,Rand(0.3,0.5)!3,[1.0,0.7,0.3]))*0.5;

	filter = RLPF.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(0.01,0.5,1.0,0.5),gate,doneAction:2);

	Out.ar(out,Pan2.ar(filter*env*amp,pan));
}).add;

)