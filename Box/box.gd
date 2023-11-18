extends Area2D

signal box_used

func used():
	emit_signal("box_used")
	queue_free()

func _ready():
	$DoorOpen.play()

func _process(delta):
	pass
