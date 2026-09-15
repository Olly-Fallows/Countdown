extends ItemUse
class_name RestoreMana

@export
var manarise: int = 5

func use(pos: Vector2i) -> void:
	var entity: Entity = GameData.map_data.get_entity(pos)
	if entity:
		entity.combat.gain_mana(manarise)
