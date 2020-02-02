extends KinematicBody2D

enum {ACCELERATE, DECELERATE, CRUISE, CHASE, FIXED, BORKED, FINISHED}
var m_state = ACCELERATE
var m_cruise_time = 0
var m_speed = 1000
const m_acceleration = .01
var m_repairedness = 0
const m_max_repairedness = 1
var m_direction = Vector2(0.0, 0.0)
var m_target_dir = Vector2(0.0, 0.0)
var m_is_repaired = false
signal sig_update_healthbar
signal sig_fixed
signal sig_borked
signal sig_finished

func is_repaired():
	return m_is_repaired
	
	
func update_healthbar():
	emit_signal("sig_update_healthbar", get_repairedness())
	pass


func get_repairedness():
	return m_repairedness
	
	
func get_max_repairedness():
	return m_max_repairedness
	
	
func add_repairedness(t_amount):
	m_repairedness += t_amount
	update_healthbar()
	

func get_new_target_dir():
#	if randf() >= .5:
	m_target_dir = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
#	else:
#		var angle_to = position.angle_to($"../Player".position)
#		m_target_dir = Vector2(cos(angle_to), sin(angle_to))
		
#	print(m_target_dir)
	return m_target_dir


func _ready():
	randomize()
	m_state = ACCELERATE
	m_cruise_time = 0
	m_speed = 1000
	m_repairedness = 0
	m_direction = Vector2(0.0, 0.0)
	m_target_dir = Vector2(0.0, 0.0)
#	m_last_pos = position
	get_new_target_dir()
	pass # Replace with function body.


func _process(delta):
	if m_state != FINISHED:
#		print("not finished")
#		print(m_state)
		var velocity = m_speed * m_direction
		var slide_velocity = move_and_slide(velocity)
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Floor":
	#			print("Collided with: ", collision.collider.name)
				
	#			m_cruise_time = randf() * 1
	#			m_state = CRUISE
	#			m_direction = Vector2(0, 0) # Vector2(cos(slide_velocity.x), sin(slide_velocity.y))
				m_direction = m_direction.bounce(collision.normal)
				get_new_target_dir()
	#	if m_last_pos == position:
	#		m_direction = Vector2(0, 0)
	#		get_new_target_dir()
	#	m_last_pos = position
		if get_repairedness() > get_max_repairedness():
			m_state = FIXED
		if get_repairedness() < -get_max_repairedness():
			m_state = BORKED
		match m_state:
	#		CHASE:
	#			position.move_toward($"../Player".position, delta * m_speed)
			ACCELERATE:
				if m_direction.length() <= m_target_dir.length():
					m_direction += m_target_dir * m_acceleration
				else:
					m_state = CRUISE
					m_cruise_time = randf() * 1
			CRUISE:
				if m_cruise_time > 0:
					m_cruise_time -= delta
				else:
					m_state = DECELERATE
			DECELERATE:
				if  m_direction.length() >= 0.01:
					m_direction *= .9
				else:
					m_direction = Vector2(0, 0)
	#				if randf() > .5:
	#					m_state = CHASE
	#				else:
					get_new_target_dir()
					m_state = ACCELERATE
			FIXED:
				if  m_direction.length() >= 0.01:
					m_direction *= .5
				else:
					m_direction = Vector2(0, 0)
					m_is_repaired = true
					emit_signal("sig_fixed")
					emit_signal("sig_finished")
					m_state = FINISHED
			BORKED:
				if  m_direction.length() >= 0.01:
					m_direction *= .5
				else:
					m_direction = Vector2(0, 0)
					emit_signal("sig_borked")
					emit_signal("sig_finished")
					m_state = FINISHED

