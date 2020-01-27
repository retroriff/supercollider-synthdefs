/*

sinfb: General purpose SinOscFB Ugen designed to mutate between pure sine waves and noise using the feedback argument.
A SynthDef that gets heavy use from me, works well for bass, chords and melody.

freq = frequency
atk = attack
sus = sustain
rel = release
fb = feedback (generally useful values are from 0-2, with 0 being pure sine waves and 2-20 being noise. More info on this in 'Between Pitch and Noise' section of guides)
amp = volume
out = channels out
pan = panning in stereo

*/

(
SynthDef(\sinfb, {
	arg freq = 440, atk = 0.01, sus = 0, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0;
	var sig, env;
	env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,1,2);
	sig = SinOscFB.ar(freq,fb,1);
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig,pan,amp));
}).add;
);