extends TileEffect
class_name Doom

@export
var damage: int = 1
@export
var type: Damage.Type = Damage.Type.NORMAL

@export
var spread_delay: int = 7
var spread_cooldown: int = spread_delay

func apply(entity: Entity) -> void:
	entity.combat.take_damage(Damage.new(damage, type))

func passive(tile: Tile) -> void:
	var doom_floor = load("uid://cbfbpjvgfxaqh")
	var doom_wall = load("uid://b1hrb5u8nebpd")
	if spread_cooldown <= 0:
		spread_cooldown = spread_delay
		var offsets: Array[Vector2i] = [
			Vector2i(1,0),
			Vector2i(-1,0),
			Vector2i(0,-1),
			Vector2i(0,1)
		]
		for offset in offsets:
			var next_tile = GameData.map_data.get_tile(tile.grid_pos+offset)
			if next_tile:
				if not next_tile.has_doom():
					if next_tile.is_transparent():
						next_tile.set_definition(doom_floor)
						return
					else:
						next_tile.set_definition(doom_wall)
						return
	else:
		spread_cooldown -= 1
