extends KinematicBody2D

export var health : int = 30
export var speed : float = 100
export var jump_strength : float = 290
export var maximum_jumps : float = 1
export var double_jump_strength : float = 125
export var gravity : float = 600

export var init_colors : PoolColorArray

var up_direction = Vector2.UP
var _jumps_made : int = 0
var _velocity : Vector2 = Vector2.ZERO

var score : int = 0


onready var skin_holder : Node2D = $Skin_holder
onready var trail : Particles2D = $Particles2D


func _ready():
	$CanvasLayer/Control.show()
	$CanvasLayer/Control/ColorRect.show()


func _physics_process(delta : float):
	var left = Input.get_action_strength("left")
	var right = Input.get_action_strength("right")
	var horizontal_direction = (
		right - left
	)
	_velocity.x = horizontal_direction * speed
	_velocity.y += gravity * delta
	
	var is_falling = _velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("jump") and is_falling
	var is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_idling = is_on_floor() and is_zero_approx(_velocity.x)
	var is_running = is_on_floor() and not is_zero_approx(_velocity.x)
	
	if is_jumping:
		_velocity.y += -jump_strength
	elif is_double_jumping:
		_jumps_made += 1
		if _jumps_made < maximum_jumps:
			_velocity.y = -jump_strength
	elif is_jump_cancelled:
		_velocity.y = 0.0
		pass
	elif is_idling or is_running:
		_jumps_made = 0
	
	_velocity = move_and_slide(
		_velocity,
		up_direction
	)
	
	_skin_handler(left, right, is_jumping, is_falling, is_running, is_idling)


func _skin_handler(left, right, jumping, falling, running, idle):
	if health > 0:
		var anim : AnimationPlayer = get_node_or_null("Skin_holder/Sprite/AnimationPlayer")
		
		if left:
			skin_holder.scale.x = -1
		if right:
			skin_holder.scale.x = 1
		
		if idle and not falling and not jumping:
			anim.play("idle")
		elif running and not jumping and not falling:
			anim.play("run")
		elif jumping or falling:
			if not anim.current_animation == "falling":
				anim.play("jump")


func _emit_trail():
	trail.emitting = true


func init_level():
	$Camera2D.smoothing_enabled = true
	$Tween.interpolate_property($CanvasLayer/Control/ColorRect, "modulate", init_colors[0], init_colors[1], 0.25,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()


func damage(amount):
	var anim : AnimationPlayer = get_node_or_null("Skin_holder/Sprite/AnimationPlayer")
	health -= amount
	if health <= 0:
		anim.play("die")


func _on_animation_finished(anim_name):
	match anim_name:
		"die":
			Loader.go_to(Global.current_level)
