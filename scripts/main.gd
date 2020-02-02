extends Node2D

enum {STORE_FRONT, STORE_BACK}
onready var m_store_front_inst = get_node("StoreFront")
var m_room = STORE_FRONT
var m_repairables = []
var m_store_back = preload("res://scenes/store_back.tscn")
var m_store_back_inst = m_store_back.instance()
var m_score = 0
onready var m_score_label = get_node("Score/Label")


func set_score(t_score):
	m_score = t_score
	m_score_label.set_text(str(m_score))


func add_score(t_add):
	set_score(m_score + t_add)


func reset_score():
	set_score(0)


func go_back():
	m_room = STORE_BACK
#	print("accepted")
	m_store_back_inst = m_store_back.instance()
	add_child(m_store_back_inst)


func go_front():
	m_store_back_inst.queue_free()
	m_room = STORE_FRONT


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && not file.ends_with(".import"):
			files.append(str(dir.get_current_dir() + "/" + file))
	dir.list_dir_end()
	return files


func pick_random_repairable():
#	print(len(m_repairables))
	var i = (randi() % (len(m_repairables) / 2))
	i *= 2
	print((m_repairables[0]))
	m_store_front_inst.set_repairable_texture(m_repairables[i])
#	print(m_repairables[i])
#	print(m_repairables[i + 1])


func _ready():
	randomize()
	reset_score()
	m_repairables = list_files_in_directory("res://graphics/repairables/")
#	for i in len(m_repairables):
#		print(m_repairables[i])
#	pick_random_repairable()
	m_store_back_inst.connect("sig_go_front", self, "go_front")
	m_store_front_inst.connect("sig_go_back", self, "go_back")


func _process(t_delta):
	match m_room:
		STORE_FRONT:
			if Input.is_action_just_pressed("ui_accept"):
				m_room = STORE_BACK
#				print("accepted")
				m_store_back_inst = m_store_back.instance()
				add_child(m_store_back_inst)
		STORE_BACK:
			if !m_store_back_inst.is_repairing():
				m_store_back_inst.queue_free()
				m_room = STORE_FRONT
	pass

