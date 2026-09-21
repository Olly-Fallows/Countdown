extends Action
class_name MoveAction

var move_offset: Vector2i

func _init(direction: Vector2i) -> void:
	move_offset = direction

func perform(entity: Entity) -> bool:
	var target: Entity = GameData.map_data.get_entity(entity.grid_pos+move_offset)
	if target:
		return false
	else:
		return await entity.move(move_offset)
