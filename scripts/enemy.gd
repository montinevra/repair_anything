extends KinematicBody2D

enum {ACCELERATE, DECELERATE, CRUISE}
var m_state = ACCELERATE
var m_cruise_time = 0
var m_speed = 500
var m_acceleration = .01
var m_repairness = 0
var m_direction = Vector2(0.0, 0.0)
var m_target_dir = Vector2(0.0, 0.0)


func get_new_target_dir():
	m_target_dir = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()

	print(m_target_dir)
	return m_target_dir


func _ready():
	randomize()
	get_new_target_dir()
	pass # Replace with function body.


func _process(delta):
	var velocity = m_speed * m_direction

	move_and_slide(velocity)
	match m_state:
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

