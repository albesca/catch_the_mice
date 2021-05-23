extends Node2D


export var drop_timeout = 1
var dropped = false


func _ready():
	$Hitbox.set_deferred("disabled", true)


func _process(delta):
	if dropped and drop_timeout == 0:
		dropped = false
		$Hitbox.set_deferred("disabled", false)
	elif dropped and drop_timeout > 0:
		drop_timeout = clamp(drop_timeout - delta, 0, drop_timeout)
