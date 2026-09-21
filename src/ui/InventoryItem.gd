extends HBoxContainer
class_name InventoryItem

signal changed

var item: Item
var texture: TextureRect = TextureRect.new()
var label: Label = Label.new()

func _init() -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER
	
	add_child(texture)
	add_child(label)

func set_item(i: Item, count: int = 1) -> void:
	item = i
	if item:
		texture.texture = item.icon
		texture.modulate = item.colour
		texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		
		label.text = item.name + " x"+str(count)
		if GameData.player.is_equiped(i):
			label.text = "[EQUIPED] "+label.text
		#label.add_theme_font_size_override("font_size", 8)
	else:
		texture.texture = null
		label.text = ""
	changed.emit()
