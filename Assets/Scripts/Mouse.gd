extends "res://Assets/Scripts/Animal.gd"


func _ready():
	move_toward_cat = false


func play_sound():
	$Squit.play()
