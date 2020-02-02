extends Node2D

onready var m_enemy = get_node("Enemy")
onready var m_enemy_sprite = get_node("Enemy/EnemySprite")

func _ready():
	m_enemy_sprite.set_texture(preload("res://graphics/tv_broken.png"))
#	m_enemy.get_node("Sprite")
	pass # Replace with function body.


