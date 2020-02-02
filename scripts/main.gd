extends Node2D

enum {STORE_FRONT, STORE_BACK}
var m_room = STORE_FRONT
var m_store_back = preload("res://scenes/store_back.tscn")
var m_store_back_inst
var m_score = 0
onready var m_score_label = get_node("Score/Label")


func set_score(t_score):
	m_score = t_score
	m_score_label.set_text(str(m_score))
	
	
func add_score(t_add):
	set_score(m_score + t_add)


func reset_score():
	set_score(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_score()
	pass # Replace with function body.

func _process(t_delta):
	match m_room:
		STORE_FRONT:
			if Input.is_action_just_pressed("ui_accept"):
				m_room = STORE_BACK
				print("accepted")
				m_store_back_inst = m_store_back.instance()
				add_child(m_store_back_inst)
		STORE_BACK:
			if !m_store_back_inst.is_repairing():
				m_store_back_inst.queue_free()
				m_room = STORE_FRONT

