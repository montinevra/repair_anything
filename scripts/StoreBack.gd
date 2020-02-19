extends Node2D

signal sig_finished
signal sig_go_front
enum {REPAIRING, FINISHED}
var m_is_repairing = true
#var m_parent = get_parent()
var m_state = REPAIRING
onready var m_enemy = get_node("Enemy")
onready var m_enemy_sprite = get_node("Enemy/EnemySprite")
onready var m_player = get_node("Player")
onready var m_healthbar = get_node("UI/Repairedness/ProgressBar")
onready var m_dialog = get_node("UI/DialogPopup")
onready var m_dialog_label = get_node("UI/DialogPopup/Label")
onready var m_dialog_timer = get_node("UI/DialogPopup/Timer")
onready var m_dialog_continue = get_node("UI/DialogPopup/Continue")


func _ready():
	m_enemy_sprite.set_texture(preload("res://graphics/repairables/TvBroken.png"))
	m_dialog_timer.set_wait_time(2)
	m_dialog_timer.connect("timeout", self, "_on_timer_timeout") 
	m_enemy.connect("sig_update_healthbar", self, "_update_healthbar")
	m_enemy.connect("sig_fixed", self, "_fixed")
	m_enemy.connect("sig_borked", self, "_borked")
#	remove_child(m_dialog)
#	remove_child(m_dialog_continue)


func _enter_tree():
	m_state = REPAIRING
	m_is_repairing = true
#	m_dialog.hide()
#	m_dialog_continue.hide()


func _process(delta):
#	print(m_dialog_timer.time_left)
	if m_enemy.is_repaired():
		pass
#		m_is_repairing = false
	if m_state == FINISHED and Input.is_action_just_pressed("ui_accept"):
		m_is_repairing = false
		go_front()


func _update_healthbar(t_health):
	m_healthbar.value = t_health
#	print(t_health)


func go_front():
	m_dialog.hide()
	m_dialog_continue.hide()
	emit_signal("sig_go_front")


func is_repairing():
	return m_is_repairing


func _on_timer_timeout():
	m_dialog_continue.show()
	m_state = FINISHED
	

func _fixed():
	m_dialog_label.text = "fixed yay!"
	_finished()

	
func _finished():
	m_player.set_finished()
	m_dialog.show()
	m_dialog_timer.start(1.2)


func _borked():
	m_dialog_label.text = "you borked it completly ):" 
	_finished()
	


