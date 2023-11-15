extends Area2D

signal box_used

func used():
	emit_signal("box_used")
	queue_free()

func _ready():
	pass

func _process(delta):
	pass
