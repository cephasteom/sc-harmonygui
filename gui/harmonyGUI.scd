(
    {
    	var state, win, scales, roots, durations, font, font2, addChord, chordsLayout, pattern, updateButtons;

        // ************************************************************* //
        // State ******************************************************* //
        // ************************************************************* //

        state = (
            scales: [Scale.major, Scale.dorian, Scale.phrygian, Scale.lydian, Scale.mixolydian, Scale.aeolian, Scale.locrian, Scale.melodicMinor, Scale.new(#[0,1,3,5,7,9,10], name: "Dorian b2"), Scale.new(#[0,2,4,6,8,9,11], name: "Lydian Aug"), Scale.new(#[0,2,4,6,7,9,10], name: "Lydian Dom"), Scale.hindu, Scale.new(#[0,2,3,5,6,8,10], name: "Half Dim"), Scale.superLocrian],
            notes: ['a','a#','b','c','c#','d','d#','e','f','f#','g','g#'],
            durations: [1,2,3,4,6,8,12,16],
            chordCache: (
                root: 0,
                scale: 0,
                duration: 0,
            ),
            chordPattern: [ ],
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

        win = Window(\harmony, Rect(300, 300, 340, 240), false);
        font = Font('Arial', 10);
        font2 = Font('Arial', 6);
        chordsLayout = HLayoutView(win, Rect(220, 0, 120, 240)).background_(Color.new(254/255, 95/255, 85/255, 0.3));

        // ************************************************************* //
        // Roots ******************************************************* //
        // ************************************************************* //

        roots = Array.fill(12, {|i| Button(win, Rect(0, 220-(i*20), 20, 20))});
        roots.collect({|root, i| root
            .font_(font)
            .states_([
                [state.notes[i]],
                [state.notes[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
            ])
            .action_({|button|
                updateButtons.value(roots, i);
                state.chordCache.root = i; // update state
            })
        });

        // ************************************************************* //
        // Scales ****************************************************** //
        // ************************************************************* //

        scales = Array.fill(state.scales.size, {|i| Button(win, Rect(20+(trunc(i/6)*40), (i%6)*40, 40, 40))});
        scales.collect({|scale, i| scale
            .font_(font2)
            .states_([
                [state.scales[i].name],
                [state.scales[i].name, Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
            ])
            .action_({|button|
                updateButtons.value(scales, i);
                state.chordCache.scale = i; // update state
            });
        });

        // ************************************************************* //
        // Durations *************************************************** //
        // ************************************************************* //

        durations = Array.fill(12, {|i| Button(win, Rect(140, 210-(i*30), 30, 30))});
        durations.collect({|dur, i| dur
            .font_(font)
            .states_([
                [state.durations[i]],
                [state.durations[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
            ])
            .action_({|button|
                updateButtons.value(durations, i);
                state.chordCache.duration = i; // update state
            })
        });

        // ************************************************************* //
        // Add Chord Button ******************************************** //
        // ************************************************************* //

        addChord = Button(win, Rect(180, 10, 30, 30)).font_(font).states_([["+"]])
            .action_({
                state.chordPattern = state.chordPattern.add(state.chordCache.copy);
                ~data.harmony = (
                    scale: state.scales[state.chordCache.scale], root: state.chordCache.root
                );
                ~data.postln;
                pattern.collect({|ch| ch.remove}); // remove chord pattern
                pattern = state.chordPattern.collect({|ch, i| // redraw from updated state
                    Button(win, Rect(220+((i%4)*30), trunc(i/4)*30, 30, 30)).font_(font)
                        .states_([
                            [i+1],
                            [i+1, Color.grey(0.2), Color.new(254/255, 95/255, 85/255)]
                        ])
                        .action_({
                            ~data.harmony = (
                                scale: state.scales[state.chordPattern[i].scale], root: state.chordPattern[i].root
                            );
                            ~data.postln;
                            updateButtons.value(pattern, i);
                            updateButtons.value(roots, state.chordPattern[i].root);
                            updateButtons.value(scales, state.chordPattern[i].scale);
                            updateButtons.value(durations, state.chordPattern[i].duration);
                        });
                });
                updateButtons.value(pattern, state.chordPattern.size - 1);
            });

    	win.onClose_({}).front;
    }
)