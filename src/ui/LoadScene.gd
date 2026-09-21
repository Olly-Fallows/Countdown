extends Button

@export
var scene: String

func _ready() -> void:
	pressed.connect(load_scene)
	
func load_scene() -> void:
	get_tree().change_scene_to_file(scene)
