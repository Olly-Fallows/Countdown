extends Action
class_name BumpAction

var move_offset: Vector2i

func _init(direction: Vector2i) -> void:
	move_offset = direction

func perform(entity: Entity) -> bool:
	var target: Entity = GameData.map_data.get_entity(entity.grid_pos+move_offset)
	if target:
		var dmg: Damage = entity.combat.get_damage(4)
		await entity.bump(move_offset)
		target.combat.take_damage(dmg)
	else:
		return await entity.move(move_offset)
	return true
