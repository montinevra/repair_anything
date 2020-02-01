extends KinematicBody2D

const BULLET = preload("res://scenes/bullet.tscn")
const RELOAD_TIME = 0.1
var m_speed = 500
var m_reloading = 0.0

func get_direction():
	var velocity = Vector2(0, 0)
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if abs(velocity.x) == 1 and abs(velocity.y) == 1:
		velocity = velocity.normalized()
	#print(velocity)
	return velocity

func shoot(t_angle):
	var bullet = BULLET.instance()
	var move_direction = t_angle - TAU/4
	var move_vector = Vector2(cos(move_direction), sin(move_direction))
	
	bullet.m_move_vec = move_vector
	bullet.position = position + move_vector * 100
	bullet.rotation = t_angle
	get_parent().add_child(bullet)
	bullet.show()
	return move_vector

func _ready():
	pass # Replace with function body.


func _process(delta):
	var movement = m_speed * get_direction()
	
	if movement.length() > 0:
		rotation = movement.angle() + TAU/4
	move_and_slide(movement)
	m_reloading -= delta
	if Input.is_action_just_pressed("shoot") && m_reloading <= 0:
		m_reloading = RELOAD_TIME
		shoot(rotation)
