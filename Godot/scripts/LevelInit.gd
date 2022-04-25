extends Node2D


export var current_level : String
export var levels_to_come_from : PoolStringArray
export var new_game : bool
export var left_right_limit : PoolIntArray
export var top_bottom_limit : PoolIntArray


onready var player : KinematicBody2D = $Player


func _ready():
	Global.current_level = current_level
	#new_game = Global.new_game
	var player_cam = $Player/Camera2D
	player_cam.smoothing_enabled = false
	player_cam.limit_left = left_right_limit[0]
	player_cam.limit_right = left_right_limit[1]
	player_cam.limit_top = top_bottom_limit[0]
	player_cam.limit_bottom = top_bottom_limit[1]
	player_cam.reset_smoothing()
	var a = Timer.new()
	add_child(a)
	a.name = "Init_Timer"
	var init_timer : Timer = $Init_Timer
	init_timer.connect("timeout", self, "_on_Init_Timer_timeout")
	init_timer.wait_time = 0.1
	init_timer.one_shot = true
	init_timer.start()

	if new_game:
		player.global_position = $New_Game.global_position
	else:
		print(false)
		for text in levels_to_come_from:
			if Global.came_from == text:
				var node = get_node(text)
				player.global_position = node.global_position


func _on_Init_Timer_timeout():
	player.init_level()
