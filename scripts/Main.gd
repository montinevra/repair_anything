extends Node2D

const M_SCN_STORE_FRONT = preload("res://scenes/StoreFront.tscn")
const M_SCN_STORE_BACK = preload("res://scenes/StoreBack.tscn")
var m_inst_store_front = M_SCN_STORE_FRONT.instance()
var m_inst_store_back = M_SCN_STORE_BACK.instance()
var m_player = m_inst_store_back.get_node("Player")
var _m_repairables_dir = []
var m_repairables = []
var _m_repairable
var m_score = 0
onready var m_score_label = get_node("Score/Label")


func _ready():
	randomize()
	_reset_score()
	_m_repairables_dir = _list_files_in_directory("res://scenes/enemies/")
	m_repairables = _list_repairables(_m_repairables_dir)
	m_inst_store_back.connect("sig_go_front", self, "_go_front")
	m_inst_store_front.connect("sig_job_accepted", self, "_go_back")
	m_player.connect("sig_shot_fired", self, "_on_shot_fired")
	m_player.connect("sig_hit_enemy", self, "add_score", [-2])
	_go_front()


func _process(t_delta):
	pass


func _set_score(t_score):
	m_score = t_score
	m_score_label.set_text(str(m_score))


func add_score(t_add):
	_set_score(m_score + t_add)


func _reset_score():
	_set_score(0)


func _go_back():
	add_child(m_inst_store_back)
	m_inst_store_back.add_child(_m_repairable)
	_m_repairable.reset_sprites()
	m_inst_store_back.connect_enemy_sigs()
	remove_child(m_inst_store_front)


func _go_front():
	add_child(m_inst_store_front)
	m_inst_store_back.remove_child(_m_repairable)
	remove_child(m_inst_store_back)
	_m_repairable = (_pick_random_repairable())



func _on_shot_fired(t_bullet):
	t_bullet.connect("sig_hit_enemy", self, "add_score", [1])


func _list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".import"):
			files.append(load(dir.get_current_dir() + "/" + file))
	dir.list_dir_end()
	return files


func _list_repairables(t_files):
	var repairables = []
	var i = 0

	while i < len(t_files):
		repairables.append(t_files[i].instance())
		print(repairables[i])
		i += 1
	return repairables


func _pick_random_repairable():
	var i = (randi() % (len(m_repairables)))
	return m_repairables[i]
