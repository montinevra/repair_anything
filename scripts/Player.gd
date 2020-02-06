extends KinematicBody2D

signal sig_shot_fired
enum {TOOL_SELECT, REPAIRING, REPAIRED, BORKED, FINISHED}
const BULLET = preload("res://scenes/Bullet.tscn")
const RELOAD_TIME = 0.1
var m_speed = 500
var m_reloading = 0.0
var m_invulnerable = .5
var m_state = REPAIRING
onready var m_main = get_node("../../")


func _process(delta):
	if m_state == REPAIRING:
		var velocity = m_speed * _get_direction()
		
		if velocity.length() > 0:
			rotation = velocity.angle() + TAU/4
		move_and_slide(velocity)
		m_reloading -= delta
		if Input.is_action_just_pressed("shoot") && m_reloading <= 0:
			m_reloading = RELOAD_TIME
			_shoot(rotation)
		m_invulnerable -= delta
		for i in get_slide_count():
			var collision = get_slide_collision(i)
	#		print("Collided with: ", collision.collider.name)
			if collision:
				var collider = collision.get_collider()
				velocity = velocity.bounce(collision.normal)
				if collider.name == "Enemy" && m_invulnerable <= 0:
					collider.add_repairedness(-.1)
#					print(collider.m_repairedness)
					m_invulnerable = .05
					m_main.add_score(-2)
	

func set_finished():
	m_state = FINISHED


func _get_direction():
	var velocity = Vector2(0, 0)
	
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if abs(velocity.x) == 1 and abs(velocity.y) == 1:
		velocity = velocity.normalized()
	#print(velocity)
	return velocity


func _shoot(t_angle):
	var bullet = BULLET.instance()
	var move_direction = t_angle - TAU/4
	var move_vector = Vector2(cos(move_direction), sin(move_direction))
	
	bullet.m_move_vec = move_vector
	bullet.position = position + move_vector * 100
	bullet.rotation = t_angle
	get_parent().add_child(bullet)
	bullet.show()
	emit_signal("sig_shot_fired", bullet)
	return move_vector
