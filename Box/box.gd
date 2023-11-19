extends Area2D

signal box_used

func used():
	emit_signal("box_used")
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.animation = "used"

func _ready():
	$DoorOpen.play()
