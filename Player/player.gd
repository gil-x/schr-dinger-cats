extends Area2D

signal pickup

@export var speed = 350

var velocity = Vector2.ZERO
var screensize = Vector2.ZERO
var path = []

func register_position():
	path.append(position)

func _ready():
	screensize = get_viewport_rect().size
	position = screensize / 2

func _process(delta):
	var margin = 50
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, margin, screensize.x - margin)
	position.y = clamp(position.y, margin, screensize.y - margin)
	register_position()

func _on_area_entered(area):
	if area.is_in_group("particles"):
		area.picked_up()
	elif area.is_in_group("boxes"):
		area.used()
	elif area.is_in_group("ghosts"):
		area.touched()
