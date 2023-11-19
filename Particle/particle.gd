extends Area2D

signal collected

func picked_up():
	emit_signal("collected")
	queue_free()

func _ready():
	pass
