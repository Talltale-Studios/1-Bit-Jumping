extends Control


var previous_tab : String = ""
var current_tab : String = "Gameplay"
var next_tab : String = ""
var tabs = ["Gameplay", "Audio", "Graphics", "Controls", "Accessibility"]


func _process(delta) -> void:
	_tab_key_switcher()


func _tab_hider(new_tab, old_tab) -> void:
	current_tab = new_tab
	var next_button : Button = get_node_or_null(str(new_tab,"Button"))
	next_button.pressed = true
	var previous_button : Button = get_node_or_null(str(old_tab, "Button"))
	previous_button.pressed = false
	var tab_to_show = get_node_or_null(str("../",new_tab,"Settings"))
	var tab_to_hide = get_node_or_null(str("../",old_tab,"Settings"))
	tab_to_show.show()
	tab_to_hide.hide()


func _tab_key_switcher() -> void:
	match current_tab:
		"Gameplay":
			current_tab = tabs[0]
			if Input.is_action_just_pressed("previous_tab"):
				_tab_hider(tabs[4], tabs[0])
			elif Input.is_action_just_pressed("next_tab"):
				_tab_hider(tabs[1], tabs[0])
		
		"Audio":
			current_tab[1]
			if Input.is_action_just_pressed("previous_tab"):
				_tab_hider(tabs[0], tabs[1])
			elif Input.is_action_just_pressed("next_tab"):
				_tab_hider(tabs[2], tabs[1])
		
		"Graphics":
			current_tab[2]
			if Input.is_action_just_pressed("previous_tab"):
				_tab_hider(tabs[1], tabs[2])
			elif Input.is_action_just_pressed("next_tab"):
				_tab_hider(tabs[3], tabs[2])
		
		"Controls":
			current_tab[3]
			if Input.is_action_just_pressed("previous_tab"):
				_tab_hider(tabs[2], tabs[3])
			elif Input.is_action_just_pressed("next_tab"):
				_tab_hider(tabs[4], tabs[3])
		
		"Accessibility":
			current_tab[4]
			if Input.is_action_just_pressed("previous_tab"):
				_tab_hider(tabs[3], tabs[4])
			elif Input.is_action_just_pressed("next_tab"):
				_tab_hider(tabs[0], tabs[4])


func _switch_tab() -> void:
	previous_tab = current_tab
	current_tab = next_tab
	var next_button : Button = get_node_or_null(str(current_tab, "Button"))
	next_button.pressed = true
	var previous_button : Button = get_node_or_null(str(previous_tab,"Button"))
	previous_button.pressed = false
	var next_ui_panel = get_node_or_null(str("../",current_tab,"Settings"))
	next_ui_panel.show()
	var previous_ui_panel = get_node_or_null(str("../",previous_tab,"Settings"))
	previous_ui_panel.hide()


func _on_GameplayButton_pressed() -> void:
	next_tab = tabs[0]
	if current_tab != next_tab:
		_switch_tab()
	else:
		get_node_or_null(str(next_tab, "Button")).pressed = true


func _on_AudioButton_pressed() -> void:
	next_tab = tabs[1]
	if current_tab != next_tab:
		_switch_tab()
	else:
		get_node_or_null(str(next_tab, "Button")).pressed = true


func _on_GraphicsButton_pressed() -> void:
	next_tab = tabs[2]
	if current_tab != next_tab:
		_switch_tab()
	else:
		get_node_or_null(str(next_tab, "Button")).pressed = true


func _on_ControlsButton_pressed() -> void:
	next_tab = tabs[3]
	if current_tab != next_tab:
		_switch_tab()
	else:
		get_node_or_null(str(next_tab, "Button")).pressed = true


func _on_AccessibilityButton_pressed() -> void:
	next_tab = tabs[4]
	if current_tab != next_tab:
		_switch_tab()
	else:
		get_node_or_null(str(next_tab, "Button")).pressed = true
