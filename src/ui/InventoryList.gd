extends Control
class_name InventoryList

var inventory: Inventory

var selected = -1

var context_menu: InventoryContextMenu = null

var vbox: VBoxContainer
var colour_rect: ColorRect

var stat_box: HBoxContainer

var items: Dictionary[Item, int] = {}

var top2_item: InventoryItem
var top1_item: InventoryItem
var middle_item: InventoryItem
var bottom1_item: InventoryItem
var bottom2_item: InventoryItem

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
	colour_rect.color = Color(0.1, 0.1, 0.1, 0.95)
	colour_rect.size = get_viewport_rect().size
	colour_rect.position = get_viewport_rect().position
	add_child(colour_rect)
	
	vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	add_child(vbox)
	
	top2_item = InventoryItem.new()
	top1_item = InventoryItem.new()
	middle_item = InventoryItem.new()
	bottom1_item = InventoryItem.new()
	bottom2_item = InventoryItem.new()
	
	vbox.item_rect_changed.connect(queue_redraw)
	
	vbox.add_child(top2_item)
	vbox.add_child(top1_item)
	vbox.add_child(middle_item)
	vbox.add_child(bottom1_item)
	vbox.add_child(bottom2_item)
	
	for item in inventory.items:
		if item in items.keys():
			items[item] += 1
		else:
			items[item] = 1
	
	if inventory.items.size() > 0:
		selected = items.keys().size()-1
	
	set_items()
	
	stat_box = HBoxContainer.new()
	stat_box.set_anchors_preset(Control.PRESET_TOP_WIDE)
	stat_box.grow_horizontal = Control.GROW_DIRECTION_BOTH
	stat_box.alignment = BoxContainer.ALIGNMENT_CENTER
	var health_label: Label = Label.new()
	health_label.text = "Health: " + str(GameData.player.combat.health) + " / " + str(GameData.player.combat.max_health)
	var mana_label: Label = Label.new()
	mana_label.text = "Mana: " + str(GameData.player.combat.mana) + " / " + str(GameData.player.combat.max_mana)
	var strength_label: Label = Label.new()
	strength_label.text = "Strength: " + str(GameData.player.combat.strength)
	var arcane_label: Label = Label.new()
	arcane_label.text = "Arcane: " + str(GameData.player.combat.arcane)
	add_child(stat_box)
	stat_box.add_child(health_label)
	stat_box.add_child(VSeparator.new())
	stat_box.add_child(mana_label)
	stat_box.add_child(VSeparator.new())
	stat_box.add_child(strength_label)
	stat_box.add_child(VSeparator.new())
	stat_box.add_child(arcane_label)

func _input(event: InputEvent) -> void:
	if context_menu:
		if event.is_action_pressed("pause"):
			context_menu.queue_free()
		return
	if event.is_action_pressed("pause"):
		queue_free()
	if event.is_action_pressed("up"):
		move_selected(-1)
	if event.is_action_pressed("down"):
		move_selected(1)
	if event.is_action_pressed("accept") or event.is_action_pressed("inventory"):
		spawn_context_menu()

func spawn_context_menu() -> void:
	context_menu = InventoryContextMenu.new(items.keys()[selected])
	add_child(context_menu)

func move_selected(dir: int) -> void:
	if items.keys().size() > 0:
		selected = clamp(selected+dir, 0, items.keys().size()-1)
		set_items()
		queue_redraw()

func set_items() -> void:
	if selected >= 0:
		middle_item.set_item(items.keys()[selected], items[items.keys()[selected]])
		if selected > 1:
			top2_item.set_item(items.keys()[selected-2], items[items.keys()[selected-2]])
		else:
			top2_item.set_item(null)
		if selected > 0:
			top1_item.set_item(items.keys()[selected-1], items[items.keys()[selected-1]])
		else:
			top1_item.set_item(null)
		if selected < items.keys().size()-1:
			bottom1_item.set_item(items.keys()[selected+1], items[items.keys()[selected+1]])
		else:
			bottom1_item.set_item(null)
		if selected < items.keys().size()-2:
			bottom2_item.set_item(items.keys()[selected+2], items[items.keys()[selected+2]])
		else:
			bottom2_item.set_item(null)
		queue_redraw.call_deferred()

func _draw() -> void:
	if selected >= 0:
		draw_rect(middle_item.get_global_rect(), Color.WHITE, false, 1)
