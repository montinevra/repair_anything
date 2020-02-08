extends KinematicBody2D

signal sig_shot_fired
signal sig_hit_enemy
signal sig_finished
enum {TOOL_SELECT, REPAIRING, REPAIRED, BORKED, FINISHED}
const BULLET = preload("res://scenes/Bullet.tscn")
const RELOAD_TIME = 0.1
const M_SPEED = 500
var m_reloading = 0.0
var m_invulnerable = .5
var m_state = REPAIRING


func _enter_tree():
	position = Vector2(450, 475)
	rotation = 0
	m_reloading = 0.0
	m_invulnerable = .5
	m_state = REPAIRING


func _process(delta):
	if m_state == REPAIRING:
		var velocity = M_SPEED * _get_direction()
		
		if velocity.length() > 0:
			rotation = velocity.angle() + TAU/4
		move_and_slide(velocity)
		if m_reloading > 0:
			m_reloading -= delta
#		if Input.is_action_just_pressed("shoot") and m_reloading <= 0:
#			m_reloading = RELOAD_TIME
#			_shoot(rotation)
		m_invulnerable -= delta
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision:
				var collider = collision.get_collider()
				if collider.name == "Enemy" and m_invulnerable <= 0:
					collider.add_repairedness(-.1)
					m_invulnerable = .05
					emit_signal("sig_hit_enemy")


func _input(event):
	if m_state == REPAIRING and Input.is_action_just_pressed("shoot") and m_reloading <= 0:
		m_reloading = RELOAD_TIME
		_shoot(rotation)


func set_finished():
	m_state = FINISHED
	emit_signal("sig_finished")


func _get_direction():
	var velocity = Vector2(0, 0)
	
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if abs(velocity.x) == 1 and abs(velocity.y) == 1:
		velocity = velocity.normalized()
	return velocity


func _shoot(t_angle):
	var bullet = BULLET.instance()
	var move_direction = t_angle - TAU/4
	var move_vector = Vector2(cos(move_direction), sin(move_direction))
	
	bullet.m_move_vec = move_vector
	bullet.position = position + move_vector * 100
	bullet.rotation = t_angle
	connect("sig_finished", bullet, "set_finished")
	get_parent().add_child(bullet)
	bullet.show()
	emit_signal("sig_shot_fired", bullet)
	return move_vector
