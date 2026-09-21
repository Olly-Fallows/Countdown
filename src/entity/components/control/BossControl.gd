extends Controller
class_name BossController

@onready
var entity: Entity = get_parent()
var path: PackedVector2Array = []

var state: STATES = STATES.WALK
enum STATES {
	WALK,
	CHARGING,
	ABILITY,
	LUNGE
}
	
func _ready() -> void:
	entity.combat.dead.connect(func():
		for t in GameData.map_data.tiles:
			if t.is_type(GameData.map_data.tile_set.cage):
				t.set_definition(GameData.map_data.tile_set.floor)
		)

func get_action() -> Action:
	if entity.visible:
		path = GameData.map_data.pathfinder.get_point_path(entity.grid_pos, GameData.player.grid_pos, true)
		path.remove_at(0)
	if not path.is_empty():
		if state == STATES.LUNGE:
			var ability = entity.abilities.abilities[0]
			state = STATES.WALK
			return AbilityAction.new(ability, path[path.size()-1])
		if state == STATES.ABILITY:
			@warning_ignore("narrowing_conversion")
			var distance: int = (entity.grid_pos - GameData.player.grid_pos).length()
			var ability = entity.abilities.abilities.pick_random()
			if ability is Lunge:
				Log.log("The Construct is charging for very big attack")
				state = STATES.LUNGE
				return null
			if ability.ability_range > distance:
				state = STATES.WALK
				return AbilityAction.new(ability, path[path.size()-1])
			state = STATES.WALK
		if state == STATES.WALK:
			@warning_ignore("narrowing_conversion")
			var distance: int = (entity.grid_pos - GameData.player.grid_pos).length()
			if distance < 8:
				if randf() < 0.4:
					state = STATES.CHARGING
			var next_pos = path[0]
			path.remove_at(0)
			return BumpAction.new(Vector2i(next_pos)-entity.grid_pos)
		if state == STATES.CHARGING:
			Log.log("The Construct is charging")
			state = STATES.ABILITY
	return null
