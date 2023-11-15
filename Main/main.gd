extends Node

@export var particle_scene : PackedScene
@export var box_scene : PackedScene
@export var ghost_scene : PackedScene
@export var playtime = 20

var screensize = Vector2.ZERO
var ghost_active = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	randomize()
	spawn_particles(randi_range(1, 6))
	
func _on_collected():
	print("collected")
	if get_tree().get_nodes_in_group("particles").size() == 1:
		spawn_box()

func spawn_particles(number):
	for i in number:
		var p = particle_scene.instantiate()
		var margin = 50
		add_child(p)
		p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		p.position.x = clamp(p.position.x, margin, screensize.x - margin)
		p.position.y = clamp(p.position.y, margin, screensize.y - margin)
		p.collected.connect(self._on_collected)

func spawn_box():
	var b = box_scene.instantiate()
	var margin = 50
	add_child(b)
	b.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	b.position.x = clamp(b.position.x, margin, screensize.x - margin)
	b.position.y = clamp(b.position.y, margin, screensize.y - margin)
	b.box_used.connect(self._on_box_used)

func spawn_ghost():
	print("spawn ghost")
	var g = ghost_scene.instantiate()
	g.path = $Player.path.duplicate()
	$Player.path = []
	add_child(g)
	ghost_active = true
	spawn_particles(3)

func _on_box_used():
	spawn_ghost()
	print("box used")

func _process(delta):
	pass


