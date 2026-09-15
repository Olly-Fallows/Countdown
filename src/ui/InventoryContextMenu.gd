extends Control
class_name InventoryContextMenu

const USE: String = "Use"
const DISCARD: String = "Discard"
const EQUIP: String = "Equip"

var item: Item

var colour_rect: ColorRect
var vbox: VBoxContainer

var options_text: Array[String]

var selected = 0

func _init(i: Item) -> void:
	item = i
	setup()
	
func setup() -> void:
	if not is_inside_tree():
		setup.call_deferred()
		return
	
	size = get_viewport_rect().size
	
	vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	colour_rect = ColorRect.new()
	colour_rect.color = Color(0,0,0,1)
	vbox.item_rect_changed.connect(update_colour_rect)
	
	add_child(colour_rect)
	add_child(vbox)
	
	colour_rect.z_index = -2
	vbox.z_index = -1
	z_index = 5
	
	options_text = get_menu_options(item)
	
	for option in options_text:
		vbox.add_child(MenuOption.new(option))
		
	queue_redraw.call_deferred()

func get_menu_options(i: Item) -> Array[String]:
	var options: Array[String] = []
	if i.use != null:
		options.append(USE)
	if i.equips != null:
		options.append(EQUIP)
	options.append(DISCARD)
	return options

func update_colour_rect() -> void:
	colour_rect.size = vbox.size+Vector2(10,10)
	colour_rect.position = vbox.position-Vector2(5,5)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		move_selected(-1)
	if event.is_action_pressed("down"):
		move_selected(1)
	if event.is_action_pressed("accept"):
		var option: MenuOption = vbox.get_child(selected)
		if option.text == USE:
			GameData.player.controller.active_ability = ItemAbility.new(item)
			GameData.player.inventory.remove_item(item)
			GameData.player.controller.inventory.queue_free()
			GameData.player.controller.queue_redraw()
		if option.text == DISCARD:
			GameData.player.inventory.remove_item(item)
			GameData.player.controller.inventory.queue_free()
		if option.text == EQUIP:
			pass
		
func move_selected(dir: int) -> void:
	if vbox.get_children().size() > 0:
		selected = clamp(selected+dir, 0, vbox.get_children().size()-1)
		queue_redraw()
		
func _draw() -> void:
	var option: MenuOption = vbox.get_child(selected)
	draw_rect(option.get_global_rect(), Color.WHITE, false, 1)

class MenuOption extends Label:
	func _init(option: String) -> void:
		text = option
		horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#add_theme_font_size_override("font_size", 8)
