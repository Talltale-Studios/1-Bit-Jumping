extends Area2D

export (int, "X", "Y") var axis_to_check = 0

export var new_left_limit : int
export var new_right_limit : int
export var new_up_limit : int
export var new_down_limit : int

export var old_left_limit : int
export var old_right_limit : int
export var old_up_limit : int
export var old_down_limit : int

var transitioned : bool = false


func _on_Level_Transition_body_entered(body):
	if body.name == "Player":
		var camera : Camera2D = $"../../Player/Camera2D"
		if axis_to_check == 0:
			# right hand of transit
			if body.global_position.x > global_position.x:
				print("right")
				print(camera)
				camera.limit_left = new_left_limit
				camera.limit_right = new_right_limit
				camera.limit_top = new_up_limit
				camera.limit_bottom = new_down_limit
				print(camera.limit_left, camera.limit_right, camera.limit_top, camera.limit_bottom)
			# left hand of transit
			else:
				camera.limit_left = old_left_limit
				camera.limit_right = old_right_limit
				camera.limit_top = old_up_limit
				camera.limit_bottom = old_down_limit
		if axis_to_check == 1:
			# above transit
			if body.global_position.y > global_position.y:
				camera.limit_left = old_left_limit
				camera.limit_right = old_right_limit
				camera.limit_top = old_up_limit
				camera.limit_bottom = old_down_limit
			# below transit
			elif body.global_position.y < global_position.y:
				camera.limit_left = new_left_limit
				camera.limit_right = new_right_limit
				camera.limit_top = new_up_limit
				camera.limit_bottom = new_down_limit
