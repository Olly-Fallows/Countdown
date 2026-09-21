extends ItemEquips
class_name BasicStats

@export
var strength: int = 0
@export
var arcane: int = 0
@export
var mana: int = 0
@export
var health: int = 0

func equip(entity: Entity) -> void:
	entity.combat.strength += strength
	entity.combat.arcane += arcane
	entity.combat.increase_health(health)
	entity.combat.increase_mana(mana)

func unequip(entity: Entity) -> void:
	entity.combat.strength -= strength
	entity.combat.arcane -= arcane
	entity.combat.decrease_health(health)
	entity.combat.decrease_mana(mana)
