extends VBoxContainer
class_name InputRemapList

@export
var actions: Array[String] = [
	"up",
	"down",
	"left",
	"right",
]

func _ready() -> void:
	for action in actions:
		add_child(InputEntry.new(action))
	get_child(1).focus()
	
	for c: int in range(1,get_children().size()):
		var entry: InputEntry = get_child(c)
		if c > 1:
			var top: InputEntry = get_child(c-1)
			entry.button.focus_neighbor_top = top.button.get_path()
		if c < get_children().size()-1:
			var bottom: InputEntry = get_child(c+1)
			entry.button.focus_neighbor_bottom = bottom.button.get_path()
