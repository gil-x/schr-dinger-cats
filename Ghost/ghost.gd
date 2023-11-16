extends Area2D

signal ghost_touched

var is_moving = true
var path = []

#func _ready():
#	pass

func touched():
	emit_signal("ghost_touched")
	queue_free()

func _process(delta):
	$Steps.text = str(len(path))
	if is_moving:
		var step = path.pop_front()
		position = step["position"]
		$StepCurrent.text = str(step["step"])
		$StepFrame.text = str(step["frame"])
		path.append(step)
		is_moving = false
	else:
		is_moving = true
