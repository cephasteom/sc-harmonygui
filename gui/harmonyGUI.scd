(
	var state, win, chords, roots, duration, font, addChord, chordsLayout, pattern, updateButtons;

    // ************************************************************* //
    // State ******************************************************* //
    // ************************************************************* //

    state = (
        labels: (
            chords: ['maj', 'min', 'aug', 'dim'],
            notes: ['a','a#','b','c','c#','d','d#','e','f','f#','g','g#'],
            duration: [1,2,3,4,6,8,12,16],
        ),
        currentChord: (
            root: 0,
            chord: 0,
            duration: 0,
        ),
        chordPattern: [ // move this out to central state
        ],
    );

    // ************************************************************* //
    // Functions *************************************************** //
    // ************************************************************* //

    updateButtons = {|array, selected| 
        array.collect({|item, i| 
            if(i != selected, {item.value = 0}, {item.value = 1}) 
        });
    };

    // ************************************************************* //
    // Layout******************************************************* //
    // ************************************************************* //

    win = Window(\harmony, Rect(300, 300, 300, 240), false);
    font = Font('Arial', 10);
    chordsLayout = HLayoutView(win, Rect(180, 0, 120, 240)).background_(Color.new(254/255, 95/255, 85/255, 0.3));

    // ************************************************************* //
    // Roots ******************************************************* //
    // ************************************************************* //

    roots = Array.fill(12, {|i| Button(win, Rect(0, 220-(i*20), 20, 20))});
    roots.collect({|root, i| root
        .font_(font)
        .states_([
            [state.labels.notes[i]],
            [state.labels.notes[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            updateButtons.value(roots, i);
            state.currentChord.root = i; // update state
        })
    });

    // ************************************************************* //
    // Chords ****************************************************** //
    // ************************************************************* //

    chords = Array.fill(4, {|i| Button(win, Rect(20, i*60, 60, 60))});
    chords.collect({|chord, i| chord
        .font_(font)
        .states_([
            [state.labels.chords[i]],
            [state.labels.chords[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            updateButtons.value(chords, i);
            state.currentChord.chord = i; // update state
        })
    });

    // ************************************************************* //
    // Durations *************************************************** //
    // ************************************************************* //

    duration = Array.fill(12, {|i| Button(win, Rect(80, 210-(i*30), 30, 30))});
    duration.collect({|dur, i| dur
        .font_(font)
        .states_([
            [state.labels.duration[i]],
            [state.labels.duration[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            updateButtons.value(duration, i);
            state.currentChord.duration = i; // update state
        })
    });

    // ************************************************************* //
    // Add Chord Button ******************************************** //
    // ************************************************************* //

    addChord = Button(win, Rect(120, 10, 30, 30)).font_(font).states_([["+"]])
        .action_({
            state.chordPattern = state.chordPattern.add(state.currentChord.copy);
            pattern.collect({|ch| ch.remove}); // remove chord pattern
            pattern = state.chordPattern.collect({|ch, i| // redraw from updated state
                Button(win, Rect(180+((i%4)*30), trunc(i/4)*30, 30, 30)).font_(font)
                    .states_([
                        [i+1],
                        [i+1, Color.grey(0.2), Color.new(254/255, 95/255, 85/255)]
                    ])
                    .action_({
                        state.chordPattern[i].postln;
                        state.currentChord = state.chordPattern[i].copy; // replace currentChord
                        updateButtons.value(pattern, i);
                        // update left hand buttons to show chord
                        updateButtons.value(roots, state.currentChord.root);
                        updateButtons.value(chords, state.currentChord.chord);
                        updateButtons.value(duration, state.currentChord.duration);
                    });
            });
            updateButtons.value(pattern, state.chordPattern.size - 1);
        });

	win.onClose_({}).front;
)