extends Area2D

signal poison

func _ready():
	$Warning.play()

func breaked():
	emit_signal("poison")
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.animation = "break"
	$Break.play()
#	queue_free()
