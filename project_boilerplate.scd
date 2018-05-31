s.quit;

// **********************************************************************
// 1. SERVER CONFIG - any server setup key to this piece
// **********************************************************************

~isHome = true;

s = Server.local;
if(~isHome, { // home vars
	s.options.outDevice_('Built-in Output');
	s.options.inDevice_('Built-in Microph');
	s.options.numOutputBusChannels_(4); 
	s.options.numInputBusChannels_(2); 
	s.options.sampleRate_(44100);
	~projectPath = "/Users/Pete/Documents/my-coding/supercollider/projects/project_harmonyGUI"; // home
	
}, { // studio vars
	s.options.device = "DN32-USB"; 
	s.options.numOutputBusChannels_(8); 
	s.options.numInputBusChannels_(8);
	s.options.sampleRate_(48000);
	~projectPath = "/Users/petethomas/code/project_harmonyGUI";
});

s.options.memSize_(2.pow(20)); // roughly 1 gig of realtime memory
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

// **********************************************************************
// 2. INIT GLOBAL VARIABLES
// **********************************************************************

~synthsPath = ~projectPath++"/synths";
~midiPath = ~projectPath++"/midi";
~guiPath = ~projectPath++"/gui";
~eventsPath = ~projectPath++"/events";

// **********************************************************************
// 3. DEFINE PIECE SPECIFIC FUNCTIONS
// **********************************************************************
~makeBuffers = {
	~buffers = Dictionary.new;
};

~makeBusses = {
	~busses = Dictionary.new;
	~busses.add(\reverb -> Bus.audio(s, 2));
};

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~makeNodes = {
	// ~mainGroup = Group.new;
	// ~reverbGroup = Group.after(~mainGroup);
	// define more fx nodes as you need them
};
~makeEvents = {
	// MIDIIn.connectAll
	e = Dictionary.new;
	e.add(\harmonyGUI -> (~guiPath++"/harmonyGUI.scd").load);	
	e.add(\chords1 -> (~eventsPath++"/chords1.scd").load);	
	e.add(\arp1 -> (~eventsPath++"/arp1.scd").load);	
};
~makeMidi = {
	// MIDIIn.connectAll;
	// e = Dictionary.new;
	// e.add(\controls -> (~midiPath++"/controls.scd").load);
};

// **********************************************************************
// 4. REGISTER FUNCTIONS WITH ABSTRACT SERVER ACTION
// **********************************************************************
ServerBoot.add(~makeBuffers); // make ~buffers
ServerBoot.add(~makeBusses); // make ~busses
ServerQuit.add(~cleanup); // clean up when quit the server

// **********************************************************************
// 5. BOOT SERVER
// **********************************************************************
s.waitForBoot({
	s.sync; 
	// synths
	(~synthsPath++"/sine.scd").load;
	(~synthsPath++"/test.scd").load;
	s.sync;
	// data
	(~projectPath++"/data.scd").load;
	// nodes and events
	ServerTree.add(~makeNodes); 
	ServerTree.add(~makeMidi); 
	ServerTree.add(~makeEvents); 
	s.freeAll;
	s.sync;
	// s.plotTree;
	// s.meter;
	"Done".postln;
});

// **********************************************************************
// 6. PERFORMANCE
// **********************************************************************
e[\harmonyGUI].value();
e[\chords1].value();
e[\arp1].value();
