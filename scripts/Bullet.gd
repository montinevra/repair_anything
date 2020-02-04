extends KinematicBody2D

const M_SPEED = 700
var m_move_vec = Vector2(0, 0)
#var _m_movement = Vector2(0, 0)
onready var m_main = get_node("../../")


func _process(delta):
	var collision = move_and_collide(m_move_vec * delta * M_SPEED)
	
	if collision:
		var collider = collision.get_collider()
		if collider.name == "Enemy":
			collider.add_repairedness(.1)
#			print(collider.m_repairedness)
			m_main.add_score(1)
		queue_free()


func set_finished():
	queue_free()
