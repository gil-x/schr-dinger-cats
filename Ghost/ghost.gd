extends Area2D

signal ghost_touched

var is_moving = true
var path = []

func _ready():
	pass

func touched():
	emit_signal("ghost_touched")
	queue_free()

func _process(delta):
	if is_moving:
		position = path.pop_front()
		path.append(position)
		is_moving = false
	else:
		is_moving = true
