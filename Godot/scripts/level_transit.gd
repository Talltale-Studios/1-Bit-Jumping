extends Node2D


export var level : String
export var came_from_level : String = ""

export var color : PoolColorArray


onready var tween : Tween  = $Tween
onready var control : Control = $CanvasLayer/Control


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		control.show()
		var err = tween.interpolate_property(control, "modulate", color[0], color[1], 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0)
		var err_2 = tween.start()


func _on_Tween_tween_all_completed():
	Globals.came_from = came_from_level
	Loader.go_to(level)
