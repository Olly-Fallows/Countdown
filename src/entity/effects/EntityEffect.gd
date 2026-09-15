extends RefCounted
class_name EntityEffect

var ttl: int = 1

func apply(_entity: Entity) -> void:
	pass

func tick(_entity: Entity) -> void:
	pass

func remove(_entity: Entity) -> void:
	pass
