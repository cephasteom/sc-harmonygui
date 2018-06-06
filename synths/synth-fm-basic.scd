// FM Synth

SynthDef(\fm, { 
	arg freq = 440,
	amp = 0.5, 
	carrRatio = 1, 
	modRatio = 2, 
	a = 0.1, d = 0.1, r = 0.8, // fractions of duration. Should add up to 1
	s = 0.4, // sus level
	modA = 0.1, modD = 0.4, modR = 0.5, // fractions of duration. Should add up to 1
	modS = 2, modMul = 4; // sus level, mod envelop multiplier
	var carrFreq, modFreq, carrSig, modSig, ampEnv, modDepthEnv;
	carrFreq = freq * carrRatio;
	modFreq = freq * modRatio;
	ampEnv = EnvGen.kr(Env.new([0, 1, s, 0], [a, d, r], 0.5), doneAction: 2);
	modDepthEnv = EnvGen.kr(Env.new([0, 1, modS, 0], [modA, modD, modR], 0.5)) * modMul;
	modSig = SinOsc.ar(modFreq, 0, modDepthEnv * modFreq);
	carrSig = SinOsc.ar(carrFreq + modSig, 0, ampEnv);
	Out.ar(0, Pan2.ar(carrSig, 0, amp));
}).add;