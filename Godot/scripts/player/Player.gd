extends KinematicBody2D

enum States {IDLE, Walk, JUMP, FALL, DASH, ATTACK}


export var attack_damage : int
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

var score := 0

var state

var jump_held := false


onready var sprite : Sprite = $Sprite
onready var trail : Particles2D = $Particles2D
onready var legAnim : AnimationPlayer = get_node_or_null("legs")
onready var torsoAnim := get_node_or_null("torso")
onready var horizontal_attack_area = $attack_areas/horizontal


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

	var attack = Input.is_action_just_pressed("attack")

	match state:
		States.IDLE:
			legAnim.play("idle")
			torsoAnim.play("idle")
		States.Walk:
			legAnim.play("run")
			torsoAnim.play("run")
		States.JUMP:
			#if legAnim.current_animation != "fall":
			legAnim.play("jump")
			torsoAnim.play("jump")
		States.FALL:
			#legAnim.play("fall")
			pass
		States.DASH:
			pass
		States.ATTACK:
			if legAnim.current_animation != "attack":
				torsoAnim.play("attack")

	_velocity = move_and_slide(_velocity, up_direction)

	var is_falling = _velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("jump") and is_falling
	var is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_idling = is_on_floor() and is_zero_approx(_velocity.x)
	var is_running = is_on_floor() and not is_zero_approx(_velocity.x)

	if is_jumping:
		_velocity.y = -jump_strength
	elif is_double_jumping:
		_jumps_made += 1
		if _jumps_made < maximum_jumps:
			_velocity.y = -jump_strength
	elif is_jump_cancelled:
		jump_held = false
		_velocity.y = 0
		pass
	elif is_idling or is_running:
		_jumps_made = 0


	if health > 0:
		if state != States.ATTACK:
			if left:
				horizontal_attack_area.rotation_degrees = -180
				$Skeleton2D.scale.x = -1
			if right:
				horizontal_attack_area.rotation_degrees = 0
				$Skeleton2D.scale.x = 1
			if is_running:
				#if legAnim.current_animation != "attack_front":
				state = States.Walk


			if is_idling:
					state = States.IDLE

			if is_falling or is_jumping:


				if state != States.FALL:
					state = States.JUMP

		if attack:
			if state != States.ATTACK:
				state = States.ATTACK


func _emit_trail():
	trail.emitting = true


func _on_animation_finished(anim_name):
	match anim_name:
		"jump":
			state = States.FALL

		"attack":
			state = States.IDLE

		"die":
			Loader.go_to(Global.current_level)


func _attack_init():
	$attack_areas/horizontal/CollisionShape2D.disabled = false
	pass

func _attack_end(body: Node) -> void:
	if body.has_method("damage"):
		body.damage(attack_damage)
	$attack_areas/horizontal/CollisionShape2D.disabled = true

func init_level():
	$Camera2D.smoothing_enabled = true
	$Tween.interpolate_property($CanvasLayer/Control/ColorRect, "modulate", init_colors[0], init_colors[1], 0.25,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()


func damage(amount):
	health -= amount
	if health <= 0:
		legAnim.play("die")




func _on_jump_length_timer_timeout() -> void:
	pass # Replace with function body.
