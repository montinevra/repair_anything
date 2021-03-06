extends Node2D

signal sig_finished
signal sig_go_front
enum {REPAIRING, FINISHED}
var m_is_repairing = true
var m_state = REPAIRING
var m_enemy
onready var m_enemy_sprite = get_node("Enemy/EnemySprite")
onready var m_player = get_node("Player")
onready var m_healthbar = get_node("UI/Repairedness/ProgressBar")
onready var m_ui = get_node("UI")
onready var m_dialog = get_node("UI/DialogPopup")
onready var m_dialog_label = get_node("UI/DialogPopup/Label")
onready var m_dialog_timer = get_node("UI/DialogPopup/Timer")
onready var m_dialog_continue = get_node("UI/DialogPopup/Continue")


func connect_enemy_sigs():
	m_enemy = get_node("Enemy")
	m_enemy.connect("sig_update_healthbar", self, "_update_healthbar")
	m_enemy.connect("sig_fixed", self, "_fixed")
	m_enemy.connect("sig_borked", self, "_borked")
	_update_healthbar(0)


func _ready():
	m_dialog_timer.set_wait_time(2)
	m_dialog_timer.connect("timeout", self, "_on_timer_timeout") 
	m_ui.remove_child(m_dialog)
	m_dialog.remove_child(m_dialog_continue)
	m_dialog_continue.connect("sig_pressed_continue", self, "go_front")


func _enter_tree():
	m_state = REPAIRING
	m_is_repairing = true



func _process(delta):
#	print(m_dialog_timer.time_left)
	if m_enemy.is_repaired():
		pass
#		m_is_repairing = false
#	if m_state == FINISHED and Input.is_action_just_pressed("ui_accept"):
#		m_is_repairing = false
#		go_front()


func _update_healthbar(t_health):
	m_healthbar.value = t_health
#	print(t_health)


func go_front():
	m_is_repairing = false
	m_ui.remove_child(m_dialog)
	m_dialog.remove_child(m_dialog_continue)
	emit_signal("sig_go_front")


func is_repairing():
	return m_is_repairing


func _on_timer_timeout():
	m_dialog.add_child(m_dialog_continue)
	m_state = FINISHED
	

func _fixed():
	m_dialog_label.text = "fixed yay!"
	_finished()


func _finished():
	m_player.set_finished()
	m_ui.add_child(m_dialog)
	m_dialog_timer.start(1.2)


func _borked():
	m_dialog_label.text = "you borked it completly ):" 
	_finished()
