extends KinematicBody2D

enum States {IDLE, Walk, JUMP, FALL, ATTACK}


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

var state


onready var sprite : Sprite = $Sprite
onready var trail : Particles2D = $Particles2D
onready var anim : AnimationPlayer = get_node_or_null("Sprite/AnimationPlayer")


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

	var jump = Input.is_action_just_pressed("jump")
	var jump_cancel = Input.is_action_just_released("jump")
	var attack = Input.is_action_just_pressed("attack")

	if not state == States.ATTACK:
		if is_on_floor():
			if left or right:
				state = States.Walk

			if not left or right and is_on_floor():
				state = States.IDLE

			if jump:
				state = States.JUMP


		if jump_cancel:
			state = States.FALL

	if attack:
		state = States.ATTACK


	match state:
		States.IDLE:
			anim.play("idle")

		States.Walk:
			anim.play("walk")

		States.JUMP:
			anim.play("jump")

		States.FALL:
			anim.play("falling")

		States.ATTACK:
			anim.play("attack_front")
	print(state)

	_velocity = move_and_slide(_velocity, up_direction)










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


	if health > 0:
		if left or right:
			#if anim.current_animation != "attack_front":
			anim.play("walk")
			if left:
				sprite.flip_h = true
			if right:
				sprite.flip_h = false

		if is_idling:
				anim.play("idle")

		if is_running:
				anim.play("run")

		if is_jumping or is_falling:
				anim.play("jump")

		if attack:
				anim.play("attack_front")






func _emit_trail():
	trail.emitting = true


func init_level():
	$Camera2D.smoothing_enabled = true
	$Tween.interpolate_property($CanvasLayer/Control/ColorRect, "modulate", init_colors[0], init_colors[1], 0.25,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()


func damage(amount):
	health -= amount
	if health <= 0:
		anim.play("die")


func _on_animation_finished(anim_name):
	match anim_name:
		"die":
			Loader.go_to(Global.current_level)
