extends CanvasLayer


export(String, FILE, '*.tscn, *.scn') var _target_scene: = ""


var _credits_screen = "res://scenes/credits_screen/CreditsScreen.tscn"


onready var start_menu : Control = $MainMenu/Overlay/StartMenu
onready var quit_confirmation : Control = $MainMenu/Overlay/QuitConfirmation
onready var settings_menu : Control = $MainMenu/Overlay/SettingsMenu


func _on_StartButton_pressed() -> void:
	Loader.go_to(_target_scene)


func _on_OptionsButton_pressed() -> void:
	start_menu.hide()
	settings_menu.show()


func _on_BackButton_pressed() -> void:
	start_menu.show()
	settings_menu.hide()


func _on_CreditsButton_pressed() -> void:
	Loader.go_to(_credits_screen)


func _on_QuitButton_pressed() -> void:
	start_menu.hide()
	quit_confirmation.show()


func _on_YesButton_pressed() -> void:
	get_tree().quit()


func _on_NoButton_pressed() -> void:
	start_menu.show()
	quit_confirmation.hide()
