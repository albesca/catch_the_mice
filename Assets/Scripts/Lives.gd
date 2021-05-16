extends Node2D


func _process(_delta):
	for i in range(get_child_count()):
		if i > 0:
			var child = get_child(i)
			if Global.lives >= i:
				child.visible = true
			else:
				child.visible = false
