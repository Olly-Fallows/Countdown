extends RefCounted
class_name EntityEffect

@export
var colour: Color = Color.WHITE
var ttl: int = 1

func apply(_entity: Entity) -> void:
	pass

func tick(_entity: Entity) -> void:
	pass

func remove(_entity: Entity) -> void:
	pass
