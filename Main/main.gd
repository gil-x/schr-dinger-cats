extends Node

signal time_up

@export var particle_scene : PackedScene
@export var box_scene : PackedScene
@export var ghost_scene : PackedScene
@export var playtime = 30

var chance_to_survive = 50
var screensize = Vector2.ZERO

#var ghost_active = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	randomize()
	$Player.hide()

func setup():
	spawn_particles(randi_range(1, 6))
	$Player.show()
	$Player.rec_path = true
	$Player.can_move = true
	$Music.play()

func _on_collected():
	print("collected")
	$Timer.stop()
	var current_time = int($HUD/MarginContainer/Time.text)
	playtime = current_time + 1
	$HUD.update_time(playtime)
	$Timer.start()
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
	g.ghost_touched.connect(self._on_ghost_touched)
	$Player.path = []
	add_child(g)
#	ghost_active = true
	spawn_particles(3)
	chance_to_survive += 5
	$HUD.update_percent(chance_to_survive)

func _on_box_used():
	spawn_ghost()
	print("box used")

func _on_ghost_touched():
	chance_to_survive -= 10
	$HUD.update_percent(chance_to_survive)

func _process(delta):
	pass




func _on_timer_timeout():
	playtime -= 1
	$HUD.update_time(playtime)
	if playtime > 0:
		$Timer.start()
	else:
		emit_signal("time_up")


func _on_hud_start_game():
	$Timer.start()
	setup()
	$HUD/StartButton.hide()


func _on_time_up():
	get_tree().call_group("particles", "queue_free")
	get_tree().call_group("ghosts", "queue_free")
	$Player.can_move = false
	$Music.stop()
	if randi_range(0, 100) <= chance_to_survive:
		$EndgameMessage.text = "You survived!"
	else:
		$EndgameMessage.text = "You died..."
	$EndgameMessage.show()
