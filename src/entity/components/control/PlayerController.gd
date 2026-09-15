extends Controller
class_name PlayerController

@onready
var player: Entity = get_parent()

var active_ability: Ability = null
var target_pos: Vector2i = Vector2i()

var inspect: InspectAbility = InspectAbility.new()

var inventory: InventoryList = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if inventory:
			inventory.queue_free()
			inventory = null
		else:
			inventory = InventoryList.new(player.inventory)
			get_tree().root.add_child(inventory)

func get_action() -> Action:
	if inventory:
		return
	if Input.is_action_just_pressed("accept"):
		if active_ability:
			if active_ability == inspect:
				inspect.perform(player, target_pos+player.grid_pos)
				active_ability = null
				target_pos = Vector2i()
				queue_redraw()
				return null
			return do_ability()
	
	if Input.is_action_just_pressed("pause"):
		if active_ability:
			active_ability = null
			queue_redraw()
		else:
			Log.log("Paused")
	
	if Input.is_action_just_pressed("inspect"):
		if active_ability == inspect:
			inspect.perform(player, target_pos+player.grid_pos)
			active_ability = null
			target_pos = Vector2i()
			queue_redraw()
			return null
		else:
			active_ability = inspect
			queue_redraw()
	for a in range(player.abilities.abilities.size()):
		if player.abilities.abilities[a]:
			if Input.is_action_just_pressed("ability"+str(a+1)):
				if player.abilities.abilities[a] == active_ability:
					return do_ability()
				else:
					active_ability = player.abilities.abilities[a]
					check_target_pos()
					queue_redraw()
	
	if active_ability:
		if Input.is_action_just_pressed("up"):
			target_pos += Vector2i(0,-1)
			queue_redraw()
		if Input.is_action_just_pressed("down"):
			target_pos += Vector2i(0,1)
			queue_redraw()
		if Input.is_action_just_pressed("left"):
			target_pos += Vector2i(-1,0)
			queue_redraw()
		if Input.is_action_just_pressed("right"):
			target_pos += Vector2i(1,0)
			queue_redraw()
	else:
		if Input.is_action_just_pressed("wait"):
			return WaitAction.new()
		
		if GameData.fov.in_combat:
			if Input.is_action_just_pressed("up"):
				return BumpAction.new(Vector2i(0,-1))
			if Input.is_action_just_pressed("down"):
				return BumpAction.new(Vector2i(0,1))
			if Input.is_action_just_pressed("left"):
				return BumpAction.new(Vector2i(-1,0))
			if Input.is_action_just_pressed("right"):
				return BumpAction.new(Vector2i(1,0))
		else:
			if Input.is_action_pressed("up"):
				return BumpAction.new(Vector2i(0,-1))
			if Input.is_action_pressed("down"):
				return BumpAction.new(Vector2i(0,1))
			if Input.is_action_pressed("left"):
				return BumpAction.new(Vector2i(-1,0))
			if Input.is_action_pressed("right"):
				return BumpAction.new(Vector2i(1,0))
				
	return null

func do_ability() -> Action:
	var ability_action = AbilityAction.new(active_ability, player.grid_pos+target_pos)
	active_ability = null
	target_pos = Vector2i()
	queue_redraw()
	return ability_action

func check_target_pos() -> void:
	pass

func _draw() -> void:
	if active_ability:
		@warning_ignore("integer_division")
		draw_rect(Rect2i(Grid.grid_to_world(target_pos)-Vector2(Grid.tile_size/2), Grid.tile_size), Color.WHITE, false, 1)
