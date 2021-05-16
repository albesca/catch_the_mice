extends Node2D


const levels_texts = [
	"Use arrows to move and space to dash.\nCatch the mouse as fast as you can\nand drop it near the stairs",
	"Now there are two mice.\nCatch them",
	"There's a third mouse.\nYou know the drill",
	"Avoid the dog while catching the mice.\nIn case you didn't notice,\nyou can't dash while holding a mouse in your mouth",
	"By now I think you know what you have to do",
	"This is the final level and there are two dogs.\nBe careful!"
]


export var lives = 9
var level
var mice = 1
var dogs = 0


func _ready():
	Global.lives = lives
	init_start_screen(null)
	
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_music"):
		Global.music = !Global.music
		
	if Input.is_action_just_pressed("ui_pause"):
		Global.pause = !Global.pause

	if Global.music and !$BackgroundMusic.playing:
		$BackgroundMusic.play()
	elif !Global.music and $BackgroundMusic.playing:
		$BackgroundMusic.stop()
		


func reset_level():
	mice += 1
	level.queue_free()
	if mice <= 6:
		dogs = clamp(round((mice - 2) / 2), 0, 2)
		init_level(null)
	else:
		var end_screen = load("res://Assets/Scenes/End.tscn").instance()
		add_child(end_screen)
		end_screen.connect("back_to_title", self, "init_start_screen")


func restart_level():
	Global.lives -= 1
	level.queue_free()
	if Global.lives > 0:
		init_level(null)
	else:
		var game_over_screen = load("res://Assets/Scenes/GameOver.tscn").instance()
		add_child(game_over_screen)
		yield(get_tree().create_timer(2), "timeout")
		game_over_screen.queue_free()
		var end_screen = load("res://Assets/Scenes/End.tscn").instance()
		add_child(end_screen)
		end_screen.connect("back_to_title", self, "init_start_screen")


func init_level(start_screen):
	if start_screen:
		start_screen.queue_free()

	var splash_screen = load("res://Assets/Scenes/Splash.tscn").instance()
	splash_screen.level = mice
	splash_screen.text = levels_texts[mice - 1]
	add_child(splash_screen)
	splash_screen.connect("start_level", self, "start_level")


func start_level(splash_screen):
	splash_screen.queue_free()
	level = load("res://Assets/Scenes/Level.tscn").instance()
	level.mice = mice
	level.dogs = dogs
	add_child(level)
	level.connect("level_done", self, "reset_level")
	level.connect("life_lost", self, "restart_level")


func init_start_screen(end_screen):
	if end_screen:
		end_screen.queue_free()

	var start_screen = load("res://Assets/Scenes/Start.tscn").instance()
	add_child(start_screen)
	mice = 1
	dogs = 0
	Global.lives = lives
	Global.total_time = 0
	start_screen.connect("start_game", self, "init_level")
