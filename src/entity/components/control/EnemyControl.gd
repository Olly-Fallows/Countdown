extends Controller
class_name EnemyController

@onready
var entity: Entity = get_parent()

var path: PackedVector2Array = []

func get_action() -> Action:
	if entity.visible:
		path = GameData.map_data.pathfinder.get_point_path(entity.grid_pos, GameData.player.grid_pos, true)
		path.remove_at(0)
		@warning_ignore("narrowing_conversion")
		var distance: int = (entity.grid_pos - GameData.player.grid_pos).length()
		for ability in entity.abilities.abilities:
			if ability.ability_range > distance:
				if ability.can_use():
					return AbilityAction.new(ability, GameData.player.grid_pos)
	if not path.is_empty():
		var next_pos = path[0]
		path.remove_at(0)
		return BumpAction.new(Vector2i(next_pos)-entity.grid_pos)
	return null
