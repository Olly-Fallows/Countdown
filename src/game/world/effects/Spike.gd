extends TileEffect
class_name Spike

@export
var damage: int = 1
@export
var type: Damage.Type = Damage.Type.NORMAL

func apply(entity: Entity) -> void:
	entity.combat.take_damage(Damage.new(damage, type))

func passive(_tile: Tile) -> void:
	pass
