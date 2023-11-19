extends Node

signal titles_end

var gwj_zap = false
var title_zap = false

func hide_background():
	$Background/AnimationPlayer.play("fade_out")
	
func show_background():
	$Background.modulate = Color(0, 0, 0, 1)

func hide_titles():
	$TitleShrodinger/AnimationPlayer.play("fade_out")
	$TitleCat/AnimationPlayer.play("fade_out")
	$TitleCatS/AnimationPlayer.play("fade_out")
	$Background.hide()

func fucking_hide_titles():
	$TitleShrodinger.hide()
	$TitleCat.hide()
	$TitleCatS.hide()

func replay_music():
	$MusicIntro.volume_db = 0
	$MusicIntro.play()

func stop_music():
	$MusicIntro/AnimationPlayer.play("fade_out")

func restart():
	$Background.show()
	$GWJ/AnimationPlayer.play("appear")
	$TitleCat/AnimationPlayer.play("from_right")
	$TitleCatS/AnimationPlayer.play("fade_in")
	$TitleShrodinger/AnimationPlayer.play("from_left")
	$MusicIntro.play()

func _ready():
	$GWJ/AnimationPlayer.play("appear")
	$TitleCat/AnimationPlayer.play("from_right")
	$TitleCatS/AnimationPlayer.play("fade_in")
	$TitleShrodinger/AnimationPlayer.play("from_left")
	$MusicIntro.play()


func _on_zap_pressed():
	if not gwj_zap:
		$GWJ/AnimationPlayer.advance(5)
		$TitleCat/AnimationPlayer.advance(5)
		$TitleCatS/AnimationPlayer.advance(5)
		$TitleShrodinger/AnimationPlayer.advance(5)
		gwj_zap = true
	if gwj_zap and not title_zap:
		$TitleCat/AnimationPlayer.advance(10)
		$TitleCatS/AnimationPlayer.advance(10)
		$TitleShrodinger/AnimationPlayer.advance(10)
		title_zap = true
		emit_signal("titles_end")


func _on_timer_timeout():
	emit_signal("titles_end")
