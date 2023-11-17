extends Area2D

signal ghost_touched

var is_moving = true
var path = []

func _ready():
	$AnimatedSprite2D.modulate = Color(255, 1, 1, 1)

func touched():
	emit_signal("ghost_touched")
	queue_free()

func _process(delta):
	
	
	$Steps.text = str(len(path))
	if is_moving:
		var step = path.pop_front()
		if step["step"] < 20:
			$CollisionShape2D.disabled = true
#			var canvas = $AnimatedSprite2D.get_canvas_item()
#			canvas.set_modulate(0, 0, 0, 0.1)
			$AnimatedSprite2D.modulate = Color(255, 1, 1, 0.1)
 
		else:
			$CollisionShape2D.disabled = false
			$AnimatedSprite2D.modulate = Color(255, 1, 1, 1)
#			$AnimatedSprite2D.modulate(0, 0, 0, 1)
		position = step["position"]
		$StepCurrent.text = str(step["step"])
		$StepFrame.text = str(step["frame"])
		path.append(step)
		is_moving = false
		
	else:
		is_moving = true
