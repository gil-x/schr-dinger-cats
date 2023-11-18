extends Area2D

signal ghost_touched

var is_moving = true
var path = []

func _ready():
	var colors = [
		Color(255, 0, 0, 1),
		Color(0, 255, 0, 1),
		Color(0, 0, 255, 1),
		Color(255, 255, 0, 1),
		Color(0, 255, 255, 1),
		Color(255, 0, 255, 1),
		Color(50, 50, 0, 1),
		Color(0, 50, 50, 1),
		Color(50, 0, 50, 1),
		Color(100, 100, 0, 1),
		Color(0, 100, 100, 1),
		Color(100, 0, 100, 1),
	]
	var index:int = randi() % colors.size()
	$AnimatedSprite2D.modulate = colors.pop_at(index)

func touched():
	emit_signal("ghost_touched")
	queue_free()

func _process(_delta):
	$Steps.text = str(len(path))
	if is_moving:
		var step = path.pop_front()
		if step["step"] < 20:
			$CollisionShape2D.disabled = true
			$AnimatedSprite2D.modulate.a = 1
		else:
			$CollisionShape2D.disabled = false
			$AnimatedSprite2D.modulate.a = 0.5
		position = step["position"]
		$AnimatedSprite2D.animation = step["animation"]
		$AnimatedSprite2D.frame = step["frame"]
		$StepCurrent.text = str(step["step"])
		$StepFrame.text = str(step["frame"])
		path.append(step)
		is_moving = false
		
	else:
		is_moving = true


