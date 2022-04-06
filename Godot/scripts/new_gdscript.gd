extends Area2D


export (int, "X", "Y") var axis_to_check = 0
export var new_left_limit : int
export var new_right_limit : int
export var new_top_limit : int
export var new_bottom_limit : int
export var old_left_limit : int
export var old_right_limit : int
export var old_top_limit : int
export var old_bottom_limit : int


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
				camera.limit_top = new_top_limit
				camera.limit_bottom = new_bottom_limit
				print(camera.limit_left, camera.limit_right, camera.limit_top, camera.limit_bottom)
			# left hand of transit
			else:
				camera.limit_left = old_left_limit
				camera.limit_right = old_right_limit
				camera.limit_top = old_top_limit
				camera.limit_bottom = old_bottom_limit
		if axis_to_check == 1:
			# above transit
			if body.global_position.y > global_position.y:
				camera.limit_left = old_left_limit
				camera.limit_right = old_right_limit
				camera.limit_top = old_top_limit
				camera.limit_bottom = old_bottom_limit
			# below transit
			elif body.global_position.y < global_position.y:
				camera.limit_left = new_left_limit
				camera.limit_right = new_right_limit
				camera.limit_top = new_top_limit
				camera.limit_bottom = new_bottom_limit
