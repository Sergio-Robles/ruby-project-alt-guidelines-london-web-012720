require_relative '../config/environment'

pid = fork{ exec "afplay", "lib/soundfile/retro-loop-intro.wav" }

#pid = fork{ exec "afplay", "lib/soundfile/Intro.mp3" }

#pid = fork{ exec "afplay", "lib/soundfile/Error-tone-sound-effect.mp3" }

#pid = fork{ exec "afplay", "lib/soundfile/purchase-succed-sound.mp3" }

#pid = fork{ exec "afplay", "lib/soundfile/Ending.mp3" }


cli = CommandLineInterface.new 
cli.title 
cli.greet 
cli.menu 
