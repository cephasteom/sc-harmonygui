(
    {
    	var state, win, scales, roots, font, font2, addChord, removeChord, reset, chordsLayout, pattern, updateButtons, red, green;

        // ************************************************************* //
        // State ******************************************************* //
        // ************************************************************* //

        state = (
            scales: [Scale.major, Scale.dorian, Scale.phrygian, Scale.lydian, Scale.mixolydian, Scale.aeolian, Scale.locrian, Scale.melodicMinor, Scale.new(#[0,1,3,5,7,9,10], name: "Dorian b2"), Scale.new(#[0,2,4,6,8,9,11], name: "Lydian Aug"), Scale.new(#[0,2,4,6,7,9,10], name: "Lydian Dom"), Scale.hindu, Scale.new(#[0,2,3,5,6,8,10], name: "Half Dim"), Scale.superLocrian],
            notes: ['a','a#','b','c','c#','d','d#','e','f','f#','g','g#'],
            chordCache: (
                root: 0,
                scale: 0,
            ),
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

        win = Window(\harmony, Rect(0, 600, 340, 240), false);
        font = Font('Arial', 10);
        font2 = Font('Arial', 6);
        red = Color.red(0.5, 0.5);
        green = Color.green(0.5, 0.5);
        chordsLayout = HLayoutView(win, Rect(220, 0, 120, 240)).background_(Color.red(0.5, 0.5));

        // ************************************************************* //
        // Roots ******************************************************* //
        // ************************************************************* //

        roots = Array.fill(12, {|i| Button(win, Rect(0, 220-(i*20), 20, 20))});
        roots.collect({|root, i| root
            .font_(font)
            .states_([
                [state.notes[i], Color.grey(0.2), Color.red(0.5, 0.3)],
                [state.notes[i], Color.white(0.2), red],
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
                [state.scales[i].name, Color.grey(0.2), Color.red(0.5, 0.1)],
                [state.scales[i].name, Color.white(0.2), red],
            ])
            .action_({|button|
                updateButtons.value(scales, i);
                state.chordCache.scale = i; // update state
            });
        });

        // ************************************************************* //
        // Add Chord Button ******************************************** //
        // ************************************************************* //

        addChord = Button(win, Rect(180, 10, 30, 30)).font_(font).states_([["+", Color.grey(0.2), Color.red(0.5, 0.1)]])
            .action_({
                // add new chord to the chord pattern
                ~data.chordPattern = ~data.chordPattern.add(state.chordCache.copy);
                // new chord becomes new harmony 
                ~data.harmony = (
                    scale: state.scales[state.chordCache.scale], root: state.chordCache.root
                );
                // redraw buttons
                pattern.collect({|ch| ch.remove}); // remove chord pattern
                pattern = ~data.chordPattern.collect({|ch, i| // redraw from updated state
                    Button(win, Rect(220+((i%4)*30), trunc(i/4)*30, 30, 30)).font_(font)
                        .states_([
                            [i+1, Color.grey(0.2), Color.red(0.5, 0.1)],
                            [i+1, Color.white(0.2), red]
                        ])
                        .action_({
                            ~data.harmony = (
                                scale: state.scales[~data.chordPattern[i].scale], root: ~data.chordPattern[i].root
                            );
                            updateButtons.value(pattern, i);
                            updateButtons.value(roots, ~data.chordPattern[i].root);
                            updateButtons.value(scales, ~data.chordPattern[i].scale);
                        });
                });
                // highlight new chord button
                updateButtons.value(pattern, ~data.chordPattern.size - 1); 
            });
        
        // ************************************************************* //
        // Remove Chord Button ***************************************** //
        // ************************************************************* //            

        removeChord = Button(win, Rect(180, 50, 30, 30)).font_(font).states_([["-", Color.grey(0.2), Color.red(0.5, 0.1)]])
            .action_({
                var finalChord = pattern.size - 1;
                if (finalChord >= 0, {
                    pattern[finalChord].remove; // remove final chord button
                    pattern.removeAt(finalChord);
                    ~data.chordPattern.removeAt(finalChord); // wipe chord pattern in data
                });
            });

        // ************************************************************* //
        // Reset Button ************************************************ //
        // ************************************************************* //         

        reset = Button(win, Rect(180, 90, 30, 30)).font_(font).states_([["x", Color.grey(0.2), Color.red(0.5, 0.1)]])
            .action_({
                pattern.collect({|ch| ch.remove}); // remove chord pattern
                pattern = [];
                ~data.chordPattern = [ ]; // wipe chord pattern in data
            });

        // ************************************************************* //
        // Init with saved data **************************************** //
        // ************************************************************* //

        // TODO: would need to convert somethings to functions so they can be reused
        // updateButtons.value(pattern, 1);
        // updateButtons.value(roots, ~data.chordPattern[1].root);
        // updateButtons.value(scales, ~data.chordPattern[1].scale);

    	win.front;
    }
)