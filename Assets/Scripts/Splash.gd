extends Node2D


signal start_level(scene)

var level = 0
var text = ""


func _ready():
	$Container/Title.text = "Level " + str(level)
	$Container/Text.text = text


func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("start_level", self)
