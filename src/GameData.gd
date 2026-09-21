extends Node

@warning_ignore("unused_signal")
signal turn_taken

var player: Entity
var map_data: MapData
var fov: FieldOfView

var current_level: int = 0
var levels: Array[String] = [
	"uid://bta7tylc4aak3", # tutorial
	"uid://b6fnepbbq2xn2", # level1
	"uid://juvsinmvm1a3", # level2
	"uid://bsx7sdyhkqd11", # level3
	"uid://de0smt7bnxtgu", # level4
	"uid://cithrw7jyxf54", # level5
	"uid://wqaf7c36arex", # level6
	"uid://cxux8mq6815vn", # level7
	"uid://o071g1o7w44g", # level8
	"uid://dpfvn4eat1lm8" # boss fight
]

var main_menu: String = "uid://bele0n1r08yy1"
var loose_screen: String = "uid://csmr1d4odbk0t"
var princess_loose_screen: String = "uid://chp6pd2mkg3f5"
var win_screen: String = "uid://csmr1d4odbk0t"

# Score stuff
var enemies_killed: int = 0
var turns_taken: int = 0
var items_pickedup: int = 0

func get_score() -> int:
	return (((current_level+1) * 500) + (enemies_killed * 50) + (items_pickedup * 25)) - turns_taken

func _ready() -> void:
	turn_taken.connect(func():
		turns_taken += 1)

func get_next_level() -> String:
	current_level += 1
	if current_level >= levels.size():
		return main_menu
	return levels[current_level]

func reset() -> void:
	var time_seed = Time.get_unix_time_from_system()
	print("Seed: "+str(time_seed))
	seed(time_seed)
	enemies_killed = 0
	turns_taken = 0
	current_level = 0
	items_pickedup = 0
	if player:
		player.queue_free()
		player = null
	if map_data:
		map_data = null
	if fov:
		fov.queue_free()
		fov = null
