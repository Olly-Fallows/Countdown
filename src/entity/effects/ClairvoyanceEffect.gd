extends EntityEffect
class_name ClairvoyanceEffect

const directions: Dictionary[Vector2, String] = {
	Vector2(-1,0): "west",
	Vector2(1,0): "east",
	Vector2(0,-1): "north",
	Vector2(0,1): "south",
	Vector2(-1,-1): "north-west",
	Vector2(1,-1): "north-east",
	Vector2(-1,1): "south-west",
	Vector2(1,1): "south-east"
}

var path: PackedVector2Array

func _init(p: PackedVector2Array, duration: int) -> void:
	path = p
	ttl = duration

func apply(_entity: Entity) -> void:
	pass

func tick(entity: Entity) -> void:
	cleanup_path(entity.grid_pos)
	Log.log(entity.name() + " should head " + get_next_direction(entity.grid_pos))

func remove(_entity: Entity) -> void:
	pass

func cleanup_path(pos: Vector2) -> void:
	if path.size() <= 0:
		return
	if path[0] == pos:
		path.remove_at(0)
	if path.size() <= 0:
		return
	var closest: Vector2 = path[0]
	for step in path:
		if (step-pos).length() <= (closest-pos).length():
			closest = step
	var step: Vector2 = path[0]
	while path.size() > 0 and step != closest:
		path.remove_at(0)
		step = path[0]

func get_next_direction(pos: Vector2) -> String:
	if path.size() <= 1:
		return "up the stairs"
	var dir = (path[0]-pos).clamp(Vector2(-1,-1), Vector2(1,1))
	return directions[dir]
