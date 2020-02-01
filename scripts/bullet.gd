extends KinematicBody2D

const m_speed = 700
var m_move_vec = Vector2(0, 0)
var m_movement = Vector2(0, 0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(m_move_vec * delta * m_speed)
	
	#if collision:
		
