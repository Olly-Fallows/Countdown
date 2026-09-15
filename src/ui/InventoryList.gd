extends Control
class_name InventoryList

var inventory: Inventory

var selected = -1

var context_menu: InventoryContextMenu = null

var vbox: VBoxContainer
var colour_rect: ColorRect

var top_item: InventoryItem
var middle_item: InventoryItem
var bottom_item: InventoryItem

func _init(i: Inventory) -> void:
	inventory = i
	theme = preload("uid://c42lb7g0x3j8u")
	setup()
	
func setup() -> void:
	if not is_inside_tree():
		setup.call_deferred()
		return
	size = get_viewport_rect().size
	
	colour_rect = ColorRect.new()
	colour_rect.color = Color(0.1, 0.1, 0.1, 0.75)
	colour_rect.size = get_viewport_rect().size
	colour_rect.position = get_viewport_rect().position
	add_child(colour_rect)
	
	vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	add_child(vbox)
	
	top_item = InventoryItem.new()
	middle_item = InventoryItem.new()
	bottom_item = InventoryItem.new()
	
	vbox.item_rect_changed.connect(queue_redraw)
	
	vbox.add_child(top_item)
	vbox.add_child(middle_item)
	vbox.add_child(bottom_item)
	
	if inventory.items.size() > 0:
		selected = inventory.items.size()-1
	
	set_items()

func _input(event: InputEvent) -> void:
	if context_menu:
		return
	if event.is_action_pressed("up"):
		move_selected(-1)
	if event.is_action_pressed("down"):
		move_selected(1)
	if event.is_action_pressed("accept"):
		spawn_context_menu()

func spawn_context_menu() -> void:
	context_menu = InventoryContextMenu.new(inventory.items[selected])
	add_child(context_menu)

func move_selected(dir: int) -> void:
	if inventory.items.size() > 0:
		selected = clamp(selected+dir, 0, inventory.items.size()-1)
		set_items()
		queue_redraw()

func set_items() -> void:
	if selected >= 0:
		middle_item.set_item(inventory.items[selected])
		if selected > 0:
			top_item.set_item(inventory.items[selected-1])
		else:
			top_item.set_item(null)
		if selected < inventory.items.size()-1:
			bottom_item.set_item(inventory.items[selected+1])
		else:
			bottom_item.set_item(null)
		queue_redraw()

func _draw() -> void:
	colour_rect.size = vbox.size + Vector2(50,50)
	colour_rect.position = vbox.position - Vector2(25,25)
	if selected >= 0:
		draw_rect(middle_item.get_global_rect(), Color.WHITE, false, 1)
