extends Area2D

signal pickup
signal vomit

@export var speed = 350

var can_move = false
var velocity = Vector2.ZERO
var screensize = Vector2.ZERO
var rec_path = false
var path = []
var path_steps = 0

func reset_path():
	path = []
	path_steps = 0

func get_stuck():
	can_move = false
	$ParalyzeTimer.start()
#	call_deferred()
	$CollisionShape2D.set_deferred("disabled", true)
#	$CollisionShape2D.disabled = true

func register_position():
	path_steps += 1 
#	path.append(position)
	path.append(
		{
			"position": position,
			"step": path_steps,
			"animation": $AnimatedSprite2D.animation,
			"frame": $AnimatedSprite2D.frame,
		}
	)

func back_to_center():
	$AnimationPlayer.play("center")
	
func grow():
	$AnimationPlayer.play("grow")

func _ready():
	screensize = get_viewport_rect().size
	position = screensize / 2

func _process(delta):
	if can_move:
		var margin_w = 160
		var margin_h = 80
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		position += velocity * speed * delta
		position.x = clamp(position.x, margin_w, screensize.x - margin_w)
		position.y = clamp(position.y, margin_h, screensize.y - margin_h)
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "back"
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "facing"
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "siding"
		elif velocity.x < 0:
			$AnimatedSprite2D.animation = "siding_left"
		else:
			$AnimatedSprite2D.animation = "idle"
#		if velocity.x != 0:
#			$AnimatedSprite2D.flip_h = velocity.x < 0
		
	if rec_path:
		register_position()


func _on_area_entered(area):
	if area.is_in_group("particles"):
		area.picked_up()
		$PickupSound.play()
	elif area.is_in_group("boxes"):
		area.used()
		$JumpSound.play()
	elif area.is_in_group("ghosts"):
		area.touched()
		$CollisionSound.play()
		$AnimatedSprite2D.play("vomit")
		get_stuck()
	elif area.is_in_group("pukes"):
		speed = 1400
		$SlideTimer.start()
		$Slide.play()
		

func _on_paralyze_timer_timeout():
	can_move = true
	$CollisionShape2D.disabled = false
	emit_signal("vomit")

func _on_slide_timer_timeout():
	speed = 350
