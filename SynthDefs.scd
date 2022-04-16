(

var instruments = [
    "808",
	"DrumKit",
    "Granular",
	"HenonN",
	"Keyboards",
	"LPlay",
	"Organs",
	"Pianos",
	"Playbuf",
	"TB303",
];

var effects = [
	"ChorusCompressor",
	"Delay",
    "Flanger",
	"HPF",
  	"LPF",
	"Reverb",
	"Vibrato",
];

instruments.do{ |synth|
	(catArgs(synth, ".scd")).loadRelative;
};

effects.do{ |synth|
	(catArgs("../Effects/", synth, ".scd")).loadRelative;
};

)
