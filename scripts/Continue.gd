extends Node2D

signal sig_pressed_continue


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("sig_pressed_continue")
