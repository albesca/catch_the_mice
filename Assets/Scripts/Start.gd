extends Node2D


signal start_game(scene)


func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("start_game", self)
