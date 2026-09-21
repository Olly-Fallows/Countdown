extends Controller
class_name PrincessController

@onready
var entity: Entity = get_parent()
var previous_pos: Vector2

func _ready() -> void:
	previous_pos = GameData.player.grid_pos

func get_action() -> Action:
	var action = MoveAction.new(Vector2i(previous_pos)-entity.grid_pos)
	previous_pos = GameData.player.grid_pos
	return action
