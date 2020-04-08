extends KinematicBody2D

signal sig_update_healthbar
signal sig_fixed
signal sig_borked
signal sig_finished
enum {ACCELERATE, DECELERATE, CRUISE, CHASE, FIXED, BORKED, FINISHED}
const M_ACCELERATION = .01
const M_MAX_REPAIREDNESS = 1
#const M_FIXED_TEXTURE = preload("res://graphics/repairables/TvRepaired.png")
const M_SPEED = 1000
#var m_broken_texture
#var m_repaired_texture
var _m_state = ACCELERATE
var _m_cruise_time = 0
var _m_repairedness = 0
var _m_direction = Vector2(0.0, 0.0)
var _m_target_dir = Vector2(0.0, 0.0)
var _m_is_repaired = false
#onready var m_sprite = get_node("EnemySprite")
onready var _m_broken_sprite = get_node("BrokenSprite")
onready var _m_repaired_sprite = get_node("RepairedSprite")

#
#func set_broken_texture(t_texture):
#	m_broken_texture = t_texture
#
#
#func set_repaired_texture(t_texture):
#	m_repaired_texture = t_texture


func reset_sprites():
	_m_broken_sprite.show()
	_m_repaired_sprite.hide()

func _ready():
	randomize()


func _enter_tree():
#	m_sprite.set_texture(m_repaired_texture)
	position = Vector2(450, 155)
	_m_state = ACCELERATE
	_m_cruise_time = 0
	_m_repairedness = 0
	_update_healthbar()
	_m_direction = Vector2(0.0, 0.0)
	_m_is_repaired = false
	_get_new_target_dir()


func _process(delta):
	if _m_state != FINISHED:
#		print("not finished")
#		print(m_state)
		var velocity = M_SPEED * _m_direction
		var slide_velocity = move_and_slide(velocity)
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Floor":
	#			print("Collided with: ", collision.collider.name)
				
	#			_m_cruise_time = randf() * 1
	#			_m_state = CRUISE
	#			_m_direction = Vector2(0, 0) # Vector2(cos(slide_velocity.x), sin(slide_velocity.y))
				_m_direction = _m_direction.bounce(collision.normal)
				_get_new_target_dir()
	#	if _m_last_pos == position:
	#		_m_direction = Vector2(0, 0)
	#		_get_new_target_dir()
	#	_m_last_pos = position
		if get_repairedness() > get_max_repairedness():
			_m_state = FIXED
			_m_broken_sprite.hide()
			_m_repaired_sprite.show()
		if get_repairedness() < -get_max_repairedness():
			_m_state = BORKED
		match _m_state:
	#		CHASE:
	#			position.move_toward($"../Player".position, delta * M_SPEED)
			ACCELERATE:
				if _m_direction.length() <= _m_target_dir.length():
					_m_direction += _m_target_dir * M_ACCELERATION
				else:
					_m_state = CRUISE
					_m_cruise_time = randf() * 1
			CRUISE:
				if _m_cruise_time > 0:
					_m_cruise_time -= delta
				else:
					_m_state = DECELERATE
			DECELERATE:
				if  _m_direction.length() >= 0.01:
					_m_direction *= .9
				else:
					_m_direction = Vector2(0, 0)
	#				if randf() > .5:
	#					_m_state = CHASE
	#				else:
					_get_new_target_dir()
					_m_state = ACCELERATE
			FIXED:
				if  _m_direction.length() >= 0.01:
					_m_direction *= .5
				else:
					_m_direction = Vector2(0, 0)
					_m_is_repaired = true
					emit_signal("sig_fixed")
					emit_signal("sig_finished")
					_m_state = FINISHED
#					m_sprite.set_texture(m_repaired_texture)
			BORKED:
				if  _m_direction.length() >= 0.01:
					_m_direction *= .5
				else:
					_m_direction = Vector2(0, 0)
					emit_signal("sig_borked")
					emit_signal("sig_finished")
					_m_state = FINISHED


func is_repaired():
	return _m_is_repaired
	
	
func get_repairedness():
	return _m_repairedness
	
	
func get_max_repairedness():
	return M_MAX_REPAIREDNESS
	
	
func add_repairedness(t_amount):
	_m_repairedness += t_amount
	_update_healthbar()
	

func _update_healthbar():
	emit_signal("sig_update_healthbar", get_repairedness())


func _get_new_target_dir():
#	if randf() >= .5:
	_m_target_dir = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
#	else:
#		var angle_to = position.angle_to($"../Player".position)
#		_m_target_dir = Vector2(cos(angle_to), sin(angle_to))
		
#	print(m_target_dir)
	return _m_target_dir
