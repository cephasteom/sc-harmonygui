(
	var state, win, chords, roots, bass, duration, font, addChord, pattern;
    win = Window(\harmony, Rect(0, 0, 500, 240), false);
    font = Font('Arial', 10);

    state = (
        labels: (
            chords: ['maj', 'min', 'aug', 'dim'],
            notes: ['a','a#','b','c','c#','d','d#','e','f','f#','g','g#'],
            duration: [1,2,3,4,6,8,12,16],
        ),
        currentChord: (
            root: 0,
            chord: "",
            bass: 0,
            duration: 0,
        ),
        chordPattern: [ // move this out to central state
            1,2,3,4,5
        ],
    );
        
    addChord = Button(win, Rect(140, 10, 30, 30)).font_(font).states_([["+"]])
        .action_({});

    roots = Array.fill(12, {|i| Button(win, Rect(0, 220-(i*20), 20, 20))});
    roots.collect({|root, i| root
        .font_(font)
        .states_([
            [state.labels.notes[i]],
            [state.labels.notes[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            roots.collect({|root, index| if(i != index, {root.value = 0}) }); // reset other buttons
        })
    });

    chords = Array.fill(4, {|i| Button(win, Rect(20, i*60, 60, 60))});
    chords.collect({|chord, i| chord
        .font_(font)
        .states_([
            [state.labels.chords[i]],
            [state.labels.chords[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            chords.collect({|chord, index| if(i != index, {chord.value = 0}) }); // reset other buttons
        })
    });

    bass = Array.fill(12, {|i| Button(win, Rect(80, 220-(i*20), 20, 20))});
    bass.collect({|bs, i| bs
        .font_(font)
        .states_([
            [state.labels.notes[i]],
            [state.labels.notes[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            bass.collect({|bs, index| if(i != index, {bs.value = 0}) }); // reset other buttons
        })        
    });

    duration = Array.fill(12, {|i| Button(win, Rect(100, 210-(i*30), 30, 30))});
    duration.collect({|dur, i| dur
        .font_(font)
        .states_([
            [state.labels.duration[i]],
            [state.labels.duration[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            duration.collect({|dur, index| if(i != index, {dur.value = 0}) }); // reset other buttons
        })
    });

    pattern = state.chordPattern.collect({|i|
        Button(win, Rect(180+(30*i), 10, 30, 30)).font_(font).states_([[i]]).action_({});
    });

	win.onClose_({}).front;
)
