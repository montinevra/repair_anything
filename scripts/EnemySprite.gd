extends Sprite


const M_BROKE_TEXTURE = preload("res://graphics/repairables/TvBroken.png")


func _enter_tree():
	set_texture(M_BROKE_TEXTURE)
