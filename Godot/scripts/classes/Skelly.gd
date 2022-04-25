extends KinematicBody2D

export (int, "Can Sleep", "Can't Sleep") var sleep_mode

export var speed : int = 60
export var patrol_speed : int = 25
export var health : int = 10
export var damage : int = 5


enum STATES {
	IDLE,
	SLEEP,
	SLEEP_TO_IDLE,
	PATROL,
	CHASE,
	ATTACK
}


var _velocity : Vector2 = Vector2()
var state = STATES.SLEEP

var dir : int
var new_pos
var horizontal_direction = 0

var target_close : bool = false

var patrol_timer : Timer


onready var target = get_node("../../Player")
onready var anim = get_node("AnimationPlayer")
onready var right_detect : RayCast2D= $Right_Detect
onready var left_detect : RayCast2D = $Left_Detect


func _ready():
	match sleep_mode:
		0:
			state = STATES.SLEEP
		1:
			state = STATES.PATROL

	var a : Timer = Timer.new()
	a.name = "Patrol_Timer"
	add_child(a)
	patrol_timer = get_node("Patrol_Timer")
	patrol_timer.one_shot = true
	patrol_timer.connect("timeout", self, "_patrol_timeout")


func _physics_process(delta):
	_velocity.y += 600* delta
	if state != STATES.IDLE:
		$Timer.stop()
	if state != STATES.PATROL:
		patrol_timer.stop()

	match state:
		STATES.IDLE:
			horizontal_direction = 0
			_play("idle")
			_velocity.x = speed * horizontal_direction
			if $Timer.time_left == 0:
				var a_rng = RandomNumberGenerator.new()
				a_rng.randomize()
				$Timer.wait_time = a_rng.randf_range(0, 2)
				$Timer.start()

		STATES.SLEEP:
			_play("sleep")
			_velocity.x = speed * horizontal_direction

		STATES.SLEEP_TO_IDLE:
			_play("sleep_to_idle")
			_velocity.x = speed * horizontal_direction

		STATES.PATROL:
			_velocity.x = patrol_speed * horizontal_direction
			_patrol_handler()
			if not left_detect.is_colliding():
				horizontal_direction = 1
			if not right_detect.is_colliding():
				horizontal_direction = -1

			match horizontal_direction:
				-1:
					_play("walk")
				1:
					_play("walk")
				0:
					_play("idle")


		STATES.CHASE:
			_velocity.x = speed * horizontal_direction
			if target.position.x > position.x:
				if right_detect.is_colliding():
					_play("walk")
					horizontal_direction = 1
				else:
					_play("idle")
					horizontal_direction = 0
			if target.position.x < position.x:
				if left_detect.is_colliding():
					_play("walk")
					horizontal_direction = -1
				else:
					_play("idle")
					horizontal_direction = 0

		STATES.ATTACK:
			_velocity.x = speed * horizontal_direction
			horizontal_direction = 0
			if anim.current_animation != "attack":
				_play("attack")

	_velocity = move_and_slide(_velocity)


# Handles the patrol state
func _patrol_handler():
	if patrol_timer.time_left == 0:

		var rangen := RandomNumberGenerator.new()
		rangen.randomize()
		var randnum = rangen.randi_range(-24, 24)

		new_pos = position.x + randnum

		var randtime = rangen.randf_range(0, 4)
		patrol_timer.wait_time = randtime
		if randnum > 0:
			horizontal_direction = 1
		elif randnum < 0:
			horizontal_direction = -1

		dir = rangen.randi_range(0,1)

		state = STATES.PATROL
		patrol_timer.start()


func _damage():
	if target_close:
		target.damage(damage)


# Animation Playing
func _play(anim_name):
	if not anim.is_playing():
		anim.play(anim_name)
	else:
		anim.play(anim_name)


func _patrol_timeout():
	state = STATES.IDLE


func _on_Detection_radios_entered(body):
	if body.is_in_group("player"):
		target_close = true
		match state:
			STATES.SLEEP:
				state = STATES.SLEEP_TO_IDLE
			STATES.IDLE:
				state = STATES.CHASE
			STATES.PATROL:
				state = STATES.CHASE
			STATES.ATTACK:
				state = STATES.CHASE


func _on_Detection_radios_exited(body):
	if body.is_in_group("player"):
		target_close = false
		state = STATES.PATROL


func _on_Attack_Range_entered(body):
	if body.is_in_group("player"):
		state = STATES.ATTACK


func _on_Attack_Range_exited(body):
	if body.is_in_group("player"):
		state = STATES.CHASE


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"sleep_to_idle":
			match target_close:
				true:
					state = STATES.CHASE
				false:
					state = STATES.IDLE


func _on_Timer_timeout():
	state = STATES.PATROL
