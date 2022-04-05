extends StaticBody2D


export (int, "1","2","3") var phase_count
export (Array, Texture) var top_phases
export (Array, Texture) var middle_phases
export (Array, Texture) var bottom_phases
export var ability_power : int


var current_phase


onready var top_sprite : Sprite = $Top
onready var bottom_sprite : Sprite = $Bottom


func _ready():
	print(phase_count)
	current_phase = phase_count + 1
	damage(1)


func damage(ability_strenght):
	print(current_phase)
	if ability_strenght >= ability_power:
		current_phase -= ability_strenght
		_assign_texture(current_phase)
		if current_phase == 0:
			$Collision.disabled = true


func _assign_texture(num):
	var middle : Node2D = $Node2D
	var middle_children = middle.get_children()
	for child in middle_children:
		child.texture = middle_phases[num]
	top_sprite.texture = top_phases[num]
	bottom_sprite.texture = bottom_phases[num]
