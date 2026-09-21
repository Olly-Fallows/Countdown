extends Ability
class_name InspectAbility

func _init() -> void:
	ability_range = 10000
	mana_cost = 0
	ability_cooldown = 0
	name = "Inspect"
	icon.atlas = load("res://assets/TileSet.png")
	icon.region = Rect2i(16*9, 16*9, 16, 16)

func perform(_caster: Entity, grid_pos: Vector2i) -> bool:
	var entity: Entity = GameData.map_data.get_entity(grid_pos)
	if entity:
		@warning_ignore("integer_division")
		Log.log(entity.name() + " is at " + str(int((float(entity.combat.health)/float(entity.combat.max_health))*100)) + "% health")
		return false
	var tile: Tile = GameData.map_data.get_tile(grid_pos)
	if tile:
		if tile.is_type(GameData.map_data.tile_set.floor):
			Log.log("The floor is made of floor")
		if tile.is_type(GameData.map_data.tile_set.wall):
			Log.log("I can't walk through walls")
		if tile.is_type(GameData.map_data.tile_set.doom_floor) or tile.is_type(GameData.map_data.tile_set.doom_wall):
			Log.log("The doom is creeping closer")
		if tile.is_type(GameData.map_data.tile_set.stairs):
			Log.log("These will take me to the next floor")
		if tile.is_type(GameData.map_data.tile_set.cage):
			Log.log("It appears to be a magic barrier")
		if tile.is_type(GameData.map_data.tile_set.crystal):
			Log.log("It holds great power")
		if tile.is_type(GameData.map_data.tile_set.broken_crystal):
			Log.log("It's cursed power has been released into the world")
		if tile.is_type(GameData.map_data.tile_set.door):
			Log.log("It's a door, I can walk through it")
	return false
