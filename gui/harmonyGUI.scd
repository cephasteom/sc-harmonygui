(
	var win, chords, roots, bass, duration, labels, font;
    win = Window(\harmony, Rect(0, 0, 500, 240), false);
    labels = (
        chords: ['maj', 'min', 'aug', 'dim'],
        notes: ['a','a#','b','c','c#','d','d#','e','f','f#','g','g#'],
        duration: [1,2,3,4,6,8,12,16],
    );
    font = Font('Arial', 10);
    
    roots = Array.fill(12, {|i| Button(win, Rect(0, 220-(i*20), 20, 20))});
    roots.collect({|root, i| root
        .font_(font)
        .states_([
            [labels.notes[i]],
            [labels.notes[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            roots.collect({|root, index| if(i != index, {root.value = 0}) }); // reset other buttons
        })
    });

    chords = Array.fill(4, {|i| Button(win, Rect(20, i*60, 60, 60))});
    chords.collect({|chord, i| chord
        .font_(font)
        .states_([
            [labels.chords[i]],
            [labels.chords[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            chords.collect({|chord, index| if(i != index, {chord.value = 0}) }); // reset other buttons
        })
    });

    bass = Array.fill(12, {|i| Button(win, Rect(80, 220-(i*20), 20, 20))});
    bass.collect({|bs, i| bs
        .font_(font)
        .states_([
            [labels.notes[i]],
            [labels.notes[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            bass.collect({|bs, index| if(i != index, {bs.value = 0}) }); // reset other buttons
        })        
    });

    duration = Array.fill(12, {|i| Button(win, Rect(100, 210-(i*30), 30, 30))});
    duration.collect({|dur, i| dur
        .font_(font)
        .states_([
            [labels.duration[i]],
            [labels.duration[i], Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
        ])
        .action_({|button|
            duration.collect({|dur, index| if(i != index, {dur.value = 0}) }); // reset other buttons
        })
    });

	win.onClose_({}).front;
)