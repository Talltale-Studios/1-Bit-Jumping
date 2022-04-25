extends Node2D


var torso_state
var legs_state


onready var torso_tree := $torso_tree
onready var legs_tree := $legs_tree
onready var torso_tween := $torso_tween
onready var legs_tween := $legs_tween


func _ready() -> void:
	torso_tree.active = true
	legs_tree.active = true
	torso_state = torso_tree["parameters/playback"]
	legs_state = legs_tree["parameters/playback"]

	torso_state.travel("idle")


func _physics_process(delta: float) -> void:
	var horizontal_dir = (Input.get_action_strength("right")-Input.get_action_strength("left"))
	if horizontal_dir > 0:
		$Skeleton2D.scale.x = 1
	elif horizontal_dir < 0:
		$Skeleton2D.scale.x = -1
	var blend_time = 0.25
	var left_pressed = Input.is_action_pressed("left")
	var left_released = Input.is_action_just_released("left")
	var right_pressed = Input.is_action_pressed("right")
	var right_released = Input.is_action_just_released("right")


	if right_pressed or left_pressed:
		torso_state.travel("BlendTree")
		legs_state.travel("BlendTree")

		torso_tween.interpolate_property(torso_tree, "parameters/BlendTree/idle_to_walk/blend_amount", torso_tree["parameters/BlendTree/idle_to_walk/blend_amount"], 1, blend_time,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
		legs_tween.interpolate_property(legs_tree, "parameters/BlendTree/idle_to_walk/blend_amount", legs_tree["parameters/BlendTree/idle_to_walk/blend_amount"], 1, blend_time,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)

		legs_tween.start()
		torso_tween.start()

	if right_released or left_released:
		torso_tween.interpolate_property(torso_tree, "parameters/BlendTree/idle_to_walk/blend_amount", torso_tree["parameters/BlendTree/idle_to_walk/blend_amount"],0 , blend_time,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
		legs_tween.interpolate_property(legs_tree, "parameters/BlendTree/idle_to_walk/blend_amount", legs_tree["parameters/BlendTree/idle_to_walk/blend_amount"],0, blend_time,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)

		legs_tween.start()
		torso_tween.start()

		torso_state.travel("BlendTree")
		legs_state.travel("BlendTree")


	pass
