extends KinematicBody2D


export var reward : String
export var amount : int


var rewarded : bool = false


func _on_Area2D_body_entered(body):
	if not rewarded:
		if body.name == "Player":
			body.set(reward, amount)
			rewarded = true
			self.queue_free()
