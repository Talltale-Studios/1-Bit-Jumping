extends Node2D


export(String, FILE, "*.tscn, *.scn") var _target_scene: = ""


func _on_BackButton_pressed() -> void:
	var err = get_tree().change_scene(_target_scene)
	if err != OK:
		print(ERR_CANT_OPEN, "ERR_CANT_OPEN", _target_scene)
