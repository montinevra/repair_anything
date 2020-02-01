extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var m_dialog_customer = get_node("DialogCustomer")
onready var m_dialog_player = get_node("DialogPlayer")
onready var m_score_label = get_node("Bg/Score/ScoreLabel")
var m_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	m_dialog_customer.text = "hi can you repair this?"	
	m_dialog_player.text = "Yes \nno"
	m_score_label.set_text(str(m_score))
	print("hello")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
