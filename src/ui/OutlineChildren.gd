extends Control
class_name OutlineChildren

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	for c in get_children():
		if c is Container:
			draw_rect(c.get_global_rect(), Color.WHITE, false, 1)
