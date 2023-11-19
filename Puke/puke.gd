extends Area2D

func _on_timer_timeout():
	$CollisionShape2D.disabled = false
