extends Node2D


signal back_to_title(scene)

func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("back_to_title", self)
