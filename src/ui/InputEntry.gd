extends HBoxContainer
class_name InputEntry

var input_key: String
var button: Button

var consuming_events: bool = false

func _init(key: String) -> void:
	input_key = key
	
	var label: Label = Label.new()
	label.text = key.capitalize()
	add_child(label)
	
	add_child(VSeparator.new())
	
	button = Button.new()
	button.text = InputMap.action_get_events(key)[0].as_text()
	add_child(button)

	button.pressed.connect(start_remap)
	
	alignment = BoxContainer.ALIGNMENT_CENTER
	
func start_remap() -> void:
	consuming_events = true
	button.grab_focus()
	button.text = "..."

func focus() -> void:
	button.grab_focus(true)

func _input(event: InputEvent) -> void:
	if consuming_events:
		if event.is_pressed():
			InputMap.action_erase_events(input_key)
			InputMap.action_add_event(input_key, event)
			button.text = InputMap.action_get_events(input_key)[0].as_text()
			if InputMap.has_action("ui_"+input_key):
				InputMap.action_erase_events("ui_"+input_key)
				InputMap.action_add_event("ui_"+input_key, event)
				button.text = InputMap.action_get_events("ui_"+input_key)[0].as_text()
			button.release_focus()
			consuming_events = false
