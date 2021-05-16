extends KinematicBody2D


var facing_right = true
var direction = Vector2(0, 0)
var action = "idle"
var collided = false
export var speed = 50
var cat_in_range = false
var since_last_move = 0
export var move_timeout = 1
var rng = RandomNumberGenerator.new()
var cat_direction = Vector2(0, 0)
var move_toward_cat = true
var player_controlled = false


func _ready():
	rng.randomize()
	while direction == Vector2(0, 0):
		direction.x = rng.randi_range(-1, 1)
		direction.y = rng.randi_range(-1, 1)

	$BodyRight.play(action)
	$BodyLeft.play(action)


func _process(delta):
	if !player_controlled and !Global.pause:
		if cat_in_range:
			cat_direction = position.direction_to(Global.cat_position)
			var direction_modifier = -1
			if move_toward_cat:
				direction_modifier = 1
			cat_direction.x = round(cat_direction.x * direction_modifier)
			cat_direction.y = round(cat_direction.y * direction_modifier)
			direction = cat_direction
		else:
			since_last_move += delta
			if since_last_move > move_timeout or collided:
				direction = Vector2(0, 0)
				collided = false
				since_last_move = 0
				while direction == Vector2(0, 0):
					direction.x = rng.randi_range(-1, 1)
					direction.y = rng.randi_range(-1, 1)


func _physics_process(delta):
	if !Global.pause:
		if direction.x == 1:
			facing_right = true
		elif direction.x == -1:
			facing_right = false
			
		if direction == Vector2(0, 0):
			action = "idle"
		else:
			action = "walk"

		if facing_right:
			$BodyRight.visible = true
			$BodyLeft.visible = false
		else:
			$BodyRight.visible = false
			$BodyLeft.visible = true

	if Global.pause:
		$BodyRight.stop()
		$BodyLeft.stop()
	else:
		if $BodyRight.animation != action or !$BodyRight.playing:
			$BodyRight.play(action)

		if $BodyLeft.animation != action or !$BodyLeft.playing:
			$BodyLeft.play(action)
			
		var collision = move_and_collide(direction.normalized() * speed * delta)
		if collision:
			collided = true


func cat_detected(_body):
	print("saw the cat!")
	cat_in_range = true
	play_sound()


func cat_lost(_body):
	print("lost the cat!")
	cat_in_range = false


func play_sound():
	pass
