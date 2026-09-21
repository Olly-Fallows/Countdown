extends TileEffect
class_name NextLevel

func apply(entity: Entity) -> void:
	if entity.is_player():
		Sfx.play_decend()
		PlayerSave.save.emit()
		entity.get_tree().change_scene_to_file(GameData.get_next_level())

func passive(_tile: Tile) -> void:
	pass
