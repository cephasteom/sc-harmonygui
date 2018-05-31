(
    {
    	var state, win, scales, roots, durations, font, font2, addChord, removeChord, reset, play, chordsLayout, pattern, updateButtons;

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

        durations = Array.fill(12, {|i| Button(win, Rect(140, i*30, 30, 30))});
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
                            [i+1],
                            [i+1, Color.grey(0.2), Color.new(254/255, 95/255, 85/255)]
                        ])
                        .action_({
                            ~data.harmony = (
                                scale: state.scales[~data.chordPattern[i].scale], root: ~data.chordPattern[i].root
                            );
                            updateButtons.value(pattern, i);
                            updateButtons.value(roots, ~data.chordPattern[i].root);
                            updateButtons.value(scales, ~data.chordPattern[i].scale);
                            updateButtons.value(durations, ~data.chordPattern[i].duration);
                        });
                });
                // highlight new chord button
                updateButtons.value(pattern, ~data.chordPattern.size - 1); 
            });
        
        // ************************************************************* //
        // Remove Chord Button ***************************************** //
        // ************************************************************* //            

        removeChord = Button(win, Rect(180, 50, 30, 30)).font_(font).states_([["-"]]);

        // ************************************************************* //
        // Reset Button ************************************************ //
        // ************************************************************* //         

        reset = Button(win, Rect(180, 90, 30, 30)).font_(font).states_([["x"]])
            .action_({
                pattern.collect({|ch| ch.remove}); // remove chord pattern
                ~data.chordPattern = [ ]; // wipe chord pattern in data
            });

        // ************************************************************* //
        // Play/Pause Button ******************************************* //
        // ************************************************************* //         

        play = Button(win, Rect(180, 200, 30, 30)).font_(font)
            .states_([
                [">"],
                ["||"],
            ]);      

        // ************************************************************* //
        // Init with saved data **************************************** //
        // ************************************************************* //

        // TODO: would need to convert somethings to functions so they can be reused
        // updateButtons.value(pattern, 1);
        // updateButtons.value(roots, ~data.chordPattern[1].root);
        // updateButtons.value(scales, ~data.chordPattern[1].scale);
        // updateButtons.value(durations, ~data.chordPattern[1].duration);

    	win.front;
    }
)