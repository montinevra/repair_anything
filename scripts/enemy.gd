extends KinematicBody2D

onready var m_raycast = get_node("RayCast2D")
enum {ACCELERATE, DECELERATE, CRUISE, CHASE}
var m_state = ACCELERATE
var m_cruise_time = 0
var m_speed = 500
var m_acceleration = .01
var m_repairness = 0
var m_direction = Vector2(0.0, 0.0)
var m_target_dir = Vector2(0.0, 0.0)
var m_last_pos = Vector2(0, 0)


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
	m_last_pos = position
	get_new_target_dir()
	pass # Replace with function body.


func _process(delta):
	var velocity = m_speed * m_direction
	var slide_velocity = move_and_slide(velocity)
	
	if get_slide_count():
		m_direction = Vector2(0, 0) # Vector2(cos(slide_velocity.x), sin(slide_velocity.y))
		get_new_target_dir()
#	if m_last_pos == position:
#		m_direction = Vector2(0, 0)
#		get_new_target_dir()
#	m_last_pos = position
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
#				if randf() > .5:
#					m_state = CHASE
#				else:
				get_new_target_dir()
				m_state = ACCELERATE
#	if m_direction.x > m_target_dir.x:
#		m_direction.x -= m_acceleration * delta
#	elif m_direction.x < m_target_dir.x:
#		m_direction.x += m_acceleration * delta
#	if m_direction.y > m_target_dir.y:
#		m_direction.y -= m_acceleration * delta
#	elif m_direction.y < m_target_dir.y:
#		m_direction.y += m_acceleration * delta
#	if m_direction.is_equal_approx(m_target_dir):
#		get_new_target_dir()



#
#
#var direction = Vector2(0, 0)
##
##func _process(delta):
##	AI_IDLE()
###    if(AI_STATE == AI_IDLE && can_Move ==true):
##        AI_IDLE()
##    if(AI_STATE == AI_CHASE && can_Move ==true):
##        AI_CHASE()
#
#func _on_move_Timer_timeout():
#	m_direction = Vector2(random(), random()).normalized() * m_speed
##	if(can_Move == false):
##		can_Move = true
##		m_direction = Vector2(random(), random()).normalized() * 50
##	else:
##		can_Move = false
#
#func random():
#	randomize()
#	return randi()%21 - 10 # range is -10 to 10
#
#func AI_IDLE():
#	move_and_slide(m_direction)
#

