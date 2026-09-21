extends Controller
class_name WanderController

@onready
var entity: Entity = get_parent()

var dir: Array[Vector2i] = [
	Vector2i(1,0),
	Vector2i(-1,0),
	Vector2i(0,-1),
	Vector2i(0,1),
]

func get_action() -> Action:
	return BumpAction.new(Vector2i(dir.pick_random()))
