extends "res://Assets/Scripts/Animal.gd"


signal bit_cat


func bit_cat(_body):
	print("bit cat")
	emit_signal("bit_cat")


func play_sound():
	$Bark.play()
