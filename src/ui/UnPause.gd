extends Button

func _ready() -> void:
	pressed.connect(unpause)
	grab_focus(true)
	
func unpause() -> void:
	GameData.player.controller.paused = false
	GameData.player.controller.pause_menu.queue_free()
