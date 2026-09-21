extends HSlider
class_name VolumeSlider

@export
var bus: String = "Master"

func _ready() -> void:
	if bus == "Master":
		grab_focus(true)
	value_changed.connect(change_volume)
	
func change_volume(v: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), v/50)
