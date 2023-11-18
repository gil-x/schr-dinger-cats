extends Node

signal time_up

@export var particle_scene : PackedScene
@export var box_scene : PackedScene
@export var ghost_scene : PackedScene
@export var puke_scene : PackedScene
@export var playtime = 20

var time_left = playtime
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
#	$Victory.stop()
#	$Loss.stop()
	$HUD/StartButton.show()
	chance_to_survive = 50
	$HUD.update_percent(chance_to_survive)
	time_left = playtime
	$HUD.update_time(time_left)
#	$Titles.replay_music()
#	$Player.hide()
	$Player.position = screensize / 2

func setup():
	# Immediately
	$HUD/StartButton.hide()
	$BoxBackground.show()
	$BoxBackground/AnimationPlayer.play("grow_up")
	$Player/AnimatedSprite2D.animation = "idle"
	$Player.grow()
	$Player.show()
	$Titles.stop_music()
	$EndgameMessage.hide()
	# Defer 1 sec
	await get_tree().create_timer(1).timeout
	$Titles.hide_titles()
	$Victory.stop()
	$Loss.stop()
	# Defer 2 secs
	await get_tree().create_timer(2).timeout
	$Timer.start()
	spawn_particles(randi_range(1, 6))
	$Player.rec_path = true
	$Player.can_move = true
	$MusicGame.play()
#	$Titles.off()
	

func _on_collected():
#	print("collected")
	$Timer.stop()
	var current_time = int($HUD/MarginContainer/Time.text)
	time_left = current_time + 1
	$HUD.update_time(time_left)
	$Timer.start()
	await get_tree().create_timer(0.1).timeout
	if get_tree().get_nodes_in_group("particles").size() == 0:
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
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left > 0:
		$Timer.start()
		if time_left > 5:
			$Tick1.play()
		else:
			$Tick2.play()
	else:
		emit_signal("time_up")
		$Tick3.play()


func _on_hud_start_game():
	setup()
	

func life_check():
	$HUD.hide_counters()
	
	await get_tree().create_timer(2).timeout
	$Player.grow()
	$Player.position = screensize / 2
	if randi_range(0, 100) <= chance_to_survive:
		$EndgameMessage.text = "KITTY IS ALIVE!"
		$Player/AnimatedSprite2D.animation = "alive"
#		$Player.show()
		$Victory.play()
	else:
		$EndgameMessage.text = "KITTY IS DEAD..."
		$Player/AnimatedSprite2D.animation = "dead"
		$Loss.play()
	$EndgameMessage.show()
	
	await get_tree().create_timer(1).timeout
	prepare_new_game()

func _on_time_up():
	$BoxBackground/AnimationPlayer.play("grow_down")
	$Player.back_to_center()
	get_tree().call_group("particles", "queue_free")
	get_tree().call_group("ghosts", "queue_free")
	get_tree().call_group("boxes", "queue_free")
	get_tree().call_group("pukes", "queue_free")
	$Player/ParalyzeTimer.stop()
	$Player.can_move = false
	$MusicGame.stop()
	life_check()

func call_hud():
	$HUD.show()
#	$Lab/AnimationPlayer.play("fade_in")
	$Titles.hide_background()
	

func _on_titles_titles_end():
	call_hud()


func _on_loss_finished():
	$Titles.replay_music()


func _on_victory_finished():
	$Titles.replay_music()


func _on_player_vomit():
	var p = puke_scene.instantiate()
	p.position = $Player.position
	call_deferred("add_child", p)

