extends Node

signal time_up

@export var particle_scene : PackedScene
@export var box_scene : PackedScene
@export var ghost_scene : PackedScene
@export var playtime = 20

var chance_to_survive = 50
var screensize = Vector2.ZERO
var margin_w = 160
var margin_h = 80

func _ready():
	screensize = get_viewport().get_visible_rect().size
	randomize()
	$Player.hide()
	$BoxBackground.hide()
#	$HUD.hide()
#	intro()

func intro():
	$MusicIntro.play()
	
func prepare_new_game():
	$HUD/StartButton.show()
	chance_to_survive = 50
	$HUD.update_percent(chance_to_survive)
	playtime = 10
	$HUD.update_time(playtime)
	
	$Player.hide()
	$Player.position = screensize / 2

func setup():
	# Immediately
	$HUD/StartButton.hide()
	$BoxBackground.show()
	$BoxBackground/AnimationPlayer.play("grow_up")
	$Player.show()
	# Defer 2 secs
	await get_tree().create_timer(2).timeout
	$Timer.start()
	spawn_particles(randi_range(1, 6))
	$Player.rec_path = true
	$Player.can_move = true
	$MusicGame.play()
#	$Titles.off()
	$EndgameMessage.hide()

func _on_collected():
#	print("collected")
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
		p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		p.position.x = clamp(p.position.x, margin_w, screensize.x - margin_w)
		p.position.y = clamp(p.position.y, margin_h, screensize.y - margin_h)
		p.collected.connect(self._on_collected)
		call_deferred("add_child", p)

func spawn_box():
	var b = box_scene.instantiate()
	b.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	b.position.x = clamp(b.position.x, margin_w, screensize.x - margin_w)
	b.position.y = clamp(b.position.y, margin_h, screensize.y - margin_h)
	b.box_used.connect(self._on_box_used)
	call_deferred("add_child", b)

func spawn_ghost():
#	print("spawn ghost")
	var g = ghost_scene.instantiate()
	g.path = $Player.path.duplicate()
	g.ghost_touched.connect(self._on_ghost_touched)
	$Player.reset_path()
	spawn_particles(3)
	chance_to_survive += 5
	$HUD.update_percent(chance_to_survive)
	call_deferred("add_child", g)

func _on_box_used():
	spawn_ghost()
#	print("box used")

func _on_ghost_touched():
	chance_to_survive -= 10
	$HUD.update_percent(chance_to_survive)

#func _process(delta):
##	$EndgameMessage.text = str($Player.can_move)
#	pass



func _on_timer_timeout():
	playtime -= 1
	$HUD.update_time(playtime)
	if playtime > 0:
		$Timer.start()
		if playtime > 5:
			$Tick1.play()
		else:
			$Tick2.play()
	else:
		emit_signal("time_up")
		$Tick3.play()


func _on_hud_start_game():
	setup()
	

func life_check():
	if randi_range(0, 100) <= chance_to_survive:
		$EndgameMessage.text = "KITTY IS ALIVE!"
	else:
		$EndgameMessage.text = "KITTY IS DEAD..."
	await get_tree().create_timer(2).timeout
	$EndgameMessage.show()
	await get_tree().create_timer(1).timeout
	prepare_new_game()

func _on_time_up():
	get_tree().call_group("particles", "queue_free")
	get_tree().call_group("ghosts", "queue_free")
	get_tree().call_group("boxes", "queue_free")
	$Player/ParalyzeTimer.stop()
	$Player.can_move = false
	$MusicGame.stop()
	life_check()

func call_hud():
	$HUD.show()
	$Lab/AnimationPlayer.play("fade_in")
	$Titles.stop_music()
	

func _on_titles_titles_end():
	call_hud()
