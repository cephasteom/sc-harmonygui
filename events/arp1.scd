{
	Pbind(
		\instrument, \test,
		\dur, 1/8,
		\scale, Pfunc { ~data.harmony.scale },
		\degree, Pwalk(
				[0,2,4].dup(3).collect({|arr, i| arr + (i*7)}).flat,
				Prand([-1,1], inf), 
				-1, 
				0, inf),
		\root, Pfunc {~data.harmony.root } - 12,
		\nharms, 1, 
		\amp, Pwhite(0.001, 0.1, inf),
		\rel, Pwalk(
			Array.series(21, 0.1, 0.01),
			Prand([-1,1], inf), 
			-1,
			0, inf),
		\pan, Pwalk(
			Array.series(21, -1.0, 0.1),
			Prand([-1,1], inf), 
			-1,
			0, inf), 
		\out, 0,
	).play(quant: 4);
}
