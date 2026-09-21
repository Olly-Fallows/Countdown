extends EntityEffect
class_name ArcaneMindEffect

func _init(duration: int) -> void:
	ttl = duration
	colour = Color.GOLD

func apply(entity: Entity) -> void:
	entity.combat.mana_regen_countdown -= 50
	entity.combat.mana_regen_delay -= 50
	entity.combat.arcane += 5
	Log.log(entity.name() + " is enlightened")

func tick(_entity: Entity) -> void:
	pass

func remove(entity: Entity) -> void:
	entity.combat.mana_regen_countdown += 50
	entity.combat.mana_regen_delay += 50
	entity.combat.arcane -= 5
	Log.log(entity.name() + " lost their focus")
