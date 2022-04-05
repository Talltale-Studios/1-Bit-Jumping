extends KinematicBody2D


export var speed : int = 45
export var health : int = 10


enum STATES {
	IDLE,
	PATROL,
	CHASE,
	ATTACK
}


var _velocity : Vector2 = Vector2()

var state = STATES.IDLE

var dir : int 
var new_pos : Vector2


onready var target = get_node("../../Player")


func _ready():
	var a : Timer = Timer.new()
	a.name = "Patrol_Timer"
	add_child(a)
	var patrol_timer : Timer = get_node("Patrol_Timer")
	patrol_timer.one_shot = true
	patrol_timer.connect("timeout", self, "_patrol_timeout")


func _physics_process(delta):
	_velocity.x = 0
	print(state)
	match state:
		STATES.IDLE:
			pass
		
		STATES.PATROL:
			match dir:
				0:
					_velocity += speed * delta
				1:
					_velocity -= speed * delta
		
		STATES.CHASE:
			if target.position.x > position.x:
				_velocity.x += speed * delta
			if target.position.x < position.x:
				_velocity.x -= speed * delta
		STATES.ATTACK:
			pass
	
	move_and_collide(_velocity)


func _patrol_handler():
	var rangen : RandomNumberGenerator = RandomNumberGenerator.new()
	var patrol_timer : Timer = get_node("Patrol_Timer")
	
	rangen.randomize()
	var randnum = rangen.randi_range(-24, 24)
	
	print(randnum)
	
	new_pos = Vector2(randnum, position.y)
	
	print(new_pos)
	
	if not patrol_timer.time_left == 0:
		var randtime = rangen.randf_range(0, 5)
		patrol_timer.wait_time = randtime
		dir = rangen.randi_range(0,1)
		state = STATES.PATROL
		patrol_timer.start()


func _patrol_timeout():
	state = STATES.IDLE
	pass


func _on_Detection_radios_entered(body):
	if body.is_in_group("player"):
		state = STATES.CHASE


func _on_Detection_radios_exited(body):
	if body.is_in_group("player"):
		state = STATES.IDLE


func _on_Attack_Range_entered(body):
	state = STATES.ATTACK


func _on_Attack_Range_exited(body):
	state = STATES.CHASE
