extends Controller
class_name DungeonPrincessController

@onready
var entity: Entity = get_parent()

var path: PackedVector2Array = []

var has_spoken1: bool = false
var has_spoken2: bool = false

func get_action() -> Action:
	if entity.visible:
		if path.size() == 0:
			path = GameData.map_data.pathfinder.get_point_path(entity.grid_pos, GameData.player.grid_pos, false)
			if path.size() == 0:
				if not has_spoken1:
					has_spoken1 = true
					Log.log("[color=#FFC0CB]Please save me[/color]")
					Log.log("[color=#FFC0CB]Break the crystal with your Arcane Bolt ("+InputMap.action_get_events("ability2")[0].as_text()+")[/color]")
			else:
				path.remove_at(0)
	if path.size() > 0 and not has_spoken2:
		has_spoken2 = true
		Log.log("[color=#FFC0CB]Amazing, \nNow please lead me to the exit using your Clairvoyance ("+InputMap.action_get_events("ability1")[0].as_text()+")[/color]")
	if has_spoken2:
		path = GameData.map_data.pathfinder.get_point_path(entity.grid_pos, GameData.player.grid_pos, true)
		path.remove_at(0)
	if not path.is_empty():
		var next_pos = path[0]
		path.remove_at(0)
		return MoveAction.new(Vector2i(next_pos)-entity.grid_pos)
	return null
