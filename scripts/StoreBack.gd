extends Node2D

onready var m_enemy = get_node("Enemy")
onready var m_enemy_sprite = get_node("Enemy/EnemySprite")
onready var m_player = get_node("Player")
var m_is_repairing = true
var m_parent = get_parent()
onready var m_healthbar = get_node("UI/Repairedness/ProgressBar")
onready var m_dialog = get_node("UI/DialogPopup")
onready var m_dialog_label = get_node("UI/DialogPopup/Label")
onready var m_dialog_timer = get_node("UI/DialogPopup/Timer")
onready var m_dialog_continue = get_node("UI/DialogPopup/Continue")
signal sig_finished
signal sig_go_front


func update_healthbar(t_health):
	m_healthbar.value = t_health
	print(t_health)


func go_front():
	emit_signal("sig_go_front")


func on_timer_timeout():
	m_dialog_continue.show()
	print("timer timeout")
	
	
func finished():
	m_player.set_finished()
	m_dialog.show()
	m_dialog_timer.start(1.5)


func fixed():
	m_dialog_label.text = "fixed yay!"
	finished()


func borked():
	m_dialog_label.text = "you borked it completly ):" 
	finished()
	
	
func is_repairing():
	return m_is_repairing


func _ready():
	m_enemy_sprite.set_texture(preload("res://graphics/tv_broken.png"))
	m_dialog_timer.set_wait_time(2)
	m_dialog_timer.connect("timeout", self, "on_timer_timeout") 
	m_enemy.connect("sig_update_healthbar", self, "update_healthbar")
	m_enemy.connect("sig_fixed", self, "fixed")
	m_enemy.connect("sig_borked", self, "borked")
	m_is_repairing = true
#	m_enemy.get_node("Sprite")
	pass # Replace with function body.


func _process(delta):
	if m_enemy.is_repaired():
		pass
#		m_is_repairing = false

