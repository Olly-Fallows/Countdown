extends RichTextLabel
class_name LogBox

func _ready() -> void:
	Log.logged.connect(append_text)
	for t in Log.log_lines:
		append_text(t)
