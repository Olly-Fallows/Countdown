extends ItemUse
class_name Heal

@export
var healing: int = 5

func use(pos: Vector2i) -> void:
	var entity: Entity = GameData.map_data.get_entity(pos)
	if entity:
		entity.combat.do_heal(healing)
