extends HBoxContainer
class_name AbilityBox

var key: String = ""
var icon: AtlasTexture

func _init(k: String, i: AtlasTexture) -> void:
	key = k
	icon = i
	var label: Label = Label.new()
	label.text = key
	#label.add_theme_font_size_override("font_size", 12)
	add_child(label)
	var texture: TextureRect = TextureRect.new()
	texture.texture = icon
	add_child(texture)
