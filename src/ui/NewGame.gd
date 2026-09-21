extends Button

@export
var scene: String

func _ready() -> void:
	grab_focus(true)
	pressed.connect(load_scene)
	
func load_scene() -> void:
	GameData.reset()
	PlayerSave.reset()
	get_tree().change_scene_to_file.call_deferred(scene)
