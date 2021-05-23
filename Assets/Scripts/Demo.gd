extends Node2D


signal life_lost
signal level_done

const dog_house_positions = [
	Vector2(-140, -70),
	Vector2(140, -70)
]

export var mice = 1
export var dogs = 1
var rng = RandomNumberGenerator.new()
var caught_mice = 0
var dog_starting_positions = []


func _ready():
	rng.randomize()
	for _i in range(mice):
		var mouse = load("res://Assets/Scenes/Mouse.tscn").instance()
		mouse.position = get_random_position()
		add_child(mouse)
	
	dog_starting_positions = dog_house_positions.duplicate()
	dog_starting_positions.shuffle()
	for _i in range(dogs):
		var dog = load("res://Assets/Scenes/Dog.tscn").instance()
		dog.position = get_dog_position()
		dog.connect("bit_cat", self, "game_over")
		add_child(dog)


func _process(_delta):
	if Global.pause:
		$Pause.visible = true
	else:
		$Pause.visible = false


func game_over():
	print("the dog bit you!")
	$Cat.died()
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("life_lost")


func leave_mouse(dropped):
	var dead_mouse = load("res://Assets/Scenes/MouseDead.tscn").instance()
	dead_mouse.position = Global.cat_position
	dead_mouse.dropped = dropped
	add_child(dead_mouse)
	print("drop mouse")
	$Stairs/Area.set_deferred("disabled", true)
	$Cat/MouseDead.visible = false
	$Cat/Bite/Reach.set_deferred("disabled", false)
	$Cat.mouse_caught = false


func drop_mouse(_body):
	leave_mouse(false)
	caught_mice += 1
	if caught_mice == mice:
		print("level done!")
		emit_signal("level_done")


func caught_mouse():
	$Stairs/Area.set_deferred("disabled", false)


func get_random_position():
	var result = Vector2(0, 0)
	result.x = rng.randi_range(-140, 140)
	result.y = rng.randi_range(-70, 100)
	return result


func get_dog_position():
	return dog_starting_positions.pop_front()
