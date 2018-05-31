{
	Pmono(\sine,
		\dur, 1/8,
		\scale, Pfunc { ~data.harmony.scale },
		\root, Pfunc { ~data.harmony.root } - 12,
		\degree, Pseq([
				[1,5,8,12],
				// Pn([1,3,6,7], 2),
				// Pn([1,3,7,6], 2),
				// Pn([1,8,9,10], 2),
				// [1,8,10,11],
				// [1,8,12],
			], inf) - 1,
		\amp, 0.25,
		\modFreq, Pwalk(
			Array.series(21, 0, 0.1),
			Prand([-1,1], inf), 
			-1,
			0, inf), 
		\modAmp, Pwhite(0, 0.01, inf),
	).play(quant: 4);
}