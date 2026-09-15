extends TileEffect
class_name NextLevel

func apply(entity: Entity) -> void:
	if entity.is_player():
		PlayerSave.save.emit()
		entity.get_tree().reload_current_scene()

func passive(_tile: Tile) -> void:
	pass
