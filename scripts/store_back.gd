extends Node2D

#const BULLET = preload("res://scenes/bullet.tscn")
#onready var m_player = get_node("player")
##onready var m_bullet = get_node("bullet")
#var m_speed = 500
#var m_bullet_speed = 700
#var m_bullet_movement = Vector2(0, 0)
#
#func get_velocity():
#	var velocity = Vector2(0, 0)
#	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
#	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#
#	if abs(velocity.x) == 1 and abs(velocity.y) == 1:
#		velocity = velocity.normalized()
#	#print(velocity)
#	return velocity
#
#func shoot(t_angle):
#	var bullet = BULLET.instance()
#	var move_direction = t_angle - TAU/4
#	var move_vector = Vector2(cos(move_direction), sin(move_direction))
#
#	#bullet.global_position = global_position
#	bullet.m_move_vec = move_vector
#	bullet.position = m_player.position + move_vector * 100
#	bullet.rotation = t_angle
#	get_parent().add_child(bullet)
#	bullet.show()
#	return move_vector
#
#
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var movement = m_speed * get_velocity()
#	if movement.length() > 0:
#		m_player.rotation = movement.angle() + TAU/4
#
#	m_player.move_and_slide(movement)
#
#	if Input.is_action_just_pressed("shoot"):
#		m_bullet_movement = shoot(m_player.rotation) * m_bullet_speed * delta
#	#print(m_player.move_and_collide(movement * delta))
#	pass
