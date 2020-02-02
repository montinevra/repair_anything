extends Node2D

onready var m_enemy = get_node("Enemy")
onready var m_enemy_sprite = get_node("Enemy/EnemySprite")
var m_is_repairing = true
var m_parent = get_parent()


func is_repairing():
	return m_is_repairing


func _ready():
	m_enemy_sprite.set_texture(preload("res://graphics/tv_broken.png"))
	m_is_repairing = true
#	m_enemy.get_node("Sprite")
	pass # Replace with function body.

func _process(delta):
	if m_enemy.is_repaired():
		m_is_repairing = false

