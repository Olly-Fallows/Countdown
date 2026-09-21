extends AudioStreamPlayer

func _ready() -> void:
	bus = "bgm"

func play_track(track: AudioStream) -> void:
	if stream != track or not playing:
		stream = track
		play()
