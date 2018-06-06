{|out = 0, oct = 1, inst = \test|
	var pattern;
	pattern = Pbind(
		\instrument, inst,
		\amp, Pwhite(0.1, 0.5) * Pfunc { ~data.patterns.randBlip.amp },
		\dur, Pexprand(0.5, 2, inf) * Pfunc { ~data.patterns.randBlip.dur },
		\scale, Pfunc { ~data.harmony.scale },
		\degree, Pxrand([1,3,5,9,10,13], inf) - 1,
		\root, Pfunc {~data.harmony.root } - 24 + (12*oct),
		\nharms, (Pkey(\amp) * 3).round,
		\pan, Pgbrown(-1, 1, 0.5, inf),
		\rel, Pkey(\degree) * 0.2,
		\out, out,
	);

	Ppar([pattern, pattern]).play;
};