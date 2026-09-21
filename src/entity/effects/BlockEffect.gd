extends EntityEffect
class_name BlockEffect

var block: int = 0

func _init(duration: int, b: int) -> void:
	ttl = duration
	block = b
	colour = Color.SADDLE_BROWN

func apply(entity: Entity) -> void:
	entity.combat.armour += block
	Log.log(entity.name() + " feels tougher")

func tick(_entity: Entity) -> void:
	pass

func remove(entity: Entity) -> void:
	entity.combat.armour -= block
	Log.log(entity.name() + " feels softer")
