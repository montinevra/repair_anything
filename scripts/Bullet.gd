extends KinematicBody2D

signal sig_hit_enemy
const M_SPEED = 700
var m_move_vec = Vector2(0, 0)


func _process(delta):
	var collision = move_and_collide(m_move_vec * delta * M_SPEED)
	
	if collision:
		var collider = collision.get_collider()
		if collider.name == "Enemy":
			collider.add_repairedness(.1)
			emit_signal("sig_hit_enemy")
		queue_free()


func set_finished():
	queue_free()
