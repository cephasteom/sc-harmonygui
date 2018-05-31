SynthDef.new(\sine, {
	arg out=0, freq=440, atck=0.1, sus=1, rel=0.5, c1=0, amp=1, pan=0, modFreq=1, modAmp=0, gate=1;
	var sig, env, mod;
	env = EnvGen.kr(Env.asr(atck, sus, rel, c1), gate, doneAction: 2);
	mod = SinOsc.kr(modFreq) * modAmp + 1;
	sig = SinOsc.ar(freq * mod, 0, amp * mod);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(out, sig);
}).add;