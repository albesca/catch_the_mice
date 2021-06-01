extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var max_speed = 60
var direction = Vector2.ZERO
var speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if direction.length() != 0 and !$AnimatedSprite.playing:
		$AnimatedSprite.play("default")
	elif direction.length() == 0 and $AnimatedSprite.playing:
		$AnimatedSprite.stop()


func _physics_process(delta):
	if direction.length() != 0 and speed > 0:
		speed = clamp(speed - delta * 100, 0, max_speed)
		var collision = move_and_collide(direction.normalized() * speed * delta)
		if collision:
			print("I hit something...")
			
	elif speed == 0:
		direction = Vector2.ZERO


func cat_hit(_body):
	var cat_direction = position.direction_to(Global.cat_position)
	cat_direction.x = round(-cat_direction.x)
	cat_direction.y = round(-cat_direction.y)
	direction = cat_direction
	speed = max_speed
	print("cat hit me!")
