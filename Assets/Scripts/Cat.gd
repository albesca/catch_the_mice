extends "res://Assets/Scripts/Animal.gd"


signal caught_mouse
signal drop_mouse(dropped)

var last_dash = 0
export var dash_timeout = 2
export var dash_speed = 4
var base_speed = speed
var mouse_caught
var dead = false


func _ready():
	mouse_caught = false
	player_controlled = true


func _process(delta):
	if !Global.pause and !dead:
		if speed > base_speed:
			speed = clamp(speed - delta * 100 * dash_speed, base_speed, base_speed * dash_speed)
		else:
			direction = Vector2(0, 0)
			if Input.is_action_pressed("ui_left"):
				direction.x = -1
			elif Input.is_action_pressed("ui_right"):
				direction.x = 1

			if Input.is_action_pressed("ui_down"):
				direction.y = 1
			elif Input.is_action_pressed("ui_up"):
				direction.y = -1
		
		if last_dash > 0:
			last_dash = clamp(last_dash - delta * 2, 0, dash_timeout)
		elif mouse_caught:
			if Input.is_action_just_pressed("ui_select"):
				emit_signal("drop_mouse", true)

		elif last_dash == 0:
			if Input.is_action_just_pressed("ui_select"):
				last_dash = dash_timeout
				speed = speed * dash_speed
				print("dash!")
		
		Global.cat_position = position


func caught_mouse(body):
	if !mouse_caught:
		mouse_caught = true
		$Bite/Reach.set_deferred("disabled", true)
		$MouseDead.visible = true
		body.queue_free()
		print("you caught a mouse!")
		emit_signal("caught_mouse")


func play_sound():
	$Wail.play()


func died():
	dead = true
	direction = Vector2(0, 0)
	speed = 0
	play_sound()
