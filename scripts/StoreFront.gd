extends Node

# var a = 2
# var b = "text"
var m_score = 0
onready var m_dialog_customer = get_node("DialogCustomer")
onready var m_dialog_player = get_node("DialogPlayer")
onready var m_repairable_sprite = get_node("Bg/tv_broken")
#onready var m_score_label = get_node("Bg/Score/ScoreLabel")


func _ready():
	m_dialog_customer.text = "hi can you repair this?"	
	m_dialog_player.text = "Yes \n"

#	print("hello")


func set_repairable_texture(t_texture):
	m_repairable_sprite.set_texture(t_texture)
