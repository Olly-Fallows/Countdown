extends Controller
class_name PlayerController

@onready
var player: Entity = get_parent()

var active_ability: Ability = null
signal target_pos_changed
var global_target_pos: Vector2 = Vector2()
var target_pos: Vector2i = Vector2i():
	set(value):
		var pos_tween: Tween = get_tree().create_tween()
		pos_tween.tween_property(self, "global_target_pos", Grid.grid_to_world(value), 0.1)
		pos_tween.tween_callback(target_pos_changed.emit)
		target_pos = value

var inspect: InspectAbility = InspectAbility.new()

var inventory: InventoryList = null

var paused: bool = false
var pause_menu: Control = null
var packed_pause_menu: PackedScene = preload("uid://6obtn17g034i")

func _input(event: InputEvent) -> void:
	if not active_ability:
		if event.is_action_pressed("inventory"):
			if inventory:
				pass
			else:
				inventory = InventoryList.new(player.inventory)
				get_tree().root.add_child(inventory)

func get_action() -> Action:
	if paused:
		if Input.is_action_just_pressed("pause"):
			pause_menu.queue_free()
			paused = false
		return
	if inventory:
		return
	if Input.is_action_just_pressed("accept"):
		if active_ability:
			if active_ability == inspect:
				check_target_pos()
				inspect.perform(player, Vector2i(target_pos)+player.grid_pos)
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
			pause_menu = packed_pause_menu.instantiate()
			get_tree().current_scene.add_child(pause_menu)
			paused = true
	
	if Input.is_action_just_pressed("inspect"):
		if active_ability == inspect:
			check_target_pos()
			inspect.perform(player, Vector2i(target_pos)+player.grid_pos)
			active_ability = null
			target_pos = Vector2i()
			queue_redraw()
			return null
		else:
			active_ability = inspect
			check_target_pos()
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
		if Input.is_action_pressed("up"):
			target_pos += Vector2i(0,-1)
			await target_pos_changed
			check_target_pos()
			queue_redraw()
		if Input.is_action_pressed("down"):
			target_pos += Vector2i(0,1)
			await target_pos_changed
			check_target_pos()
			queue_redraw()
		if Input.is_action_pressed("left"):
			target_pos += Vector2i(-1,0)
			await target_pos_changed
			check_target_pos()
			queue_redraw()
		if Input.is_action_pressed("right"):
			target_pos += Vector2i(1,0)
			await target_pos_changed
			check_target_pos()
			queue_redraw()
	else:
		if Input.is_action_just_pressed("wait"):
			return WaitAction.new()
		
		#if GameData.fov.in_combat:
			#if Input.is_action_just_pressed("up"):
				#return BumpAction.new(Vector2i(0,-1))
			#if Input.is_action_just_pressed("down"):
				#return BumpAction.new(Vector2i(0,1))
			#if Input.is_action_just_pressed("left"):
				#return BumpAction.new(Vector2i(-1,0))
			#if Input.is_action_just_pressed("right"):
				#return BumpAction.new(Vector2i(1,0))
		#else:
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
	check_target_pos()
	var ability_action = AbilityAction.new(active_ability, player.grid_pos+Vector2i(target_pos))
	active_ability = null
	target_pos = Vector2i()
	queue_redraw()
	return ability_action

func check_target_pos() -> void:
	if active_ability:
		if target_pos.length() > active_ability.ability_range:
			target_pos = Vector2i(Vector2(target_pos).normalized()*active_ability.ability_range)

func _process(_delta: float) -> void:
	if active_ability:
		queue_redraw()

func _draw() -> void:
	if active_ability:
		@warning_ignore("integer_division")
		draw_rect(Rect2i(global_target_pos-Vector2(Grid.tile_size/2), Grid.tile_size), Color.WHITE, false, 1)
