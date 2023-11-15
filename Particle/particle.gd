extends Area2D

signal collected

var screensize = Vector2.ZERO

func picked_up():
	emit_signal("collected")
	queue_free()

func _ready():
	pass

func _process(delta):
	pass
