extends KinematicBody2D

const m_speed = 700
var m_move_vec = Vector2(0, 0)
var m_movement = Vector2(0, 0)

func _ready():
	pass # Replace with function body.

func _process(delta):
	var collision = move_and_collide(m_move_vec * delta * m_speed)
	
	if collision:
		var collider = collision.get_collider()
		if collider.name == "Enemy":
			collider.add_repairedness(.1)
			print(collider.m_repairedness)
			pass
		get_parent().remove_child(self)
