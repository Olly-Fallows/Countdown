extends Control
class_name Map

@export
var map_size: Vector2i = Vector2i(75,75)
@export
var map_scale: Vector2i = Vector2i(1,1)

func _ready() -> void:
	custom_minimum_size = map_size * map_scale
	queue_redraw()
	GameData.turn_taken.connect(queue_redraw)

func _draw() -> void:
	if GameData.player:
		@warning_ignore("integer_division")
		var msize = Vector2i(size)/map_scale
		var offset: Vector2i = Vector2i(size/2) - GameData.player.grid_pos
		for x in range(max(0, GameData.player.grid_pos.x - (msize.x/2)), min(GameData.map_data.size.x, GameData.player.grid_pos.x + (msize.x/2))):
			for y in range(max(0, GameData.player.grid_pos.y - (msize.y/2)), min(GameData.map_data.size.y, GameData.player.grid_pos.y + (msize.y/2))):
				var tile = GameData.map_data.get_tile_xy(x,y)
				if tile.is_explored:
					draw_rect(Rect2(Vector2i(x+offset.x,y+offset.y)*map_scale, map_scale), tile.colour())
				if tile.is_in_view:
					var entity = GameData.map_data.get_entity_xy(x,y)
					if entity:
						draw_rect(Rect2(Vector2i(x+offset.x,y+offset.y)*map_scale, map_scale), entity.colour())
