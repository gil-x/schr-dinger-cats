extends Node

func _ready():
	$GWJ/AnimationPlayer.play("appear")
	$Fader/AnimationPlayer.play("fade_in")
	$TitleCat/AnimationPlayer.play("from_right")
	$TitleCatS/AnimationPlayer.play("fade_in")
	$TitleShrodinger/AnimationPlayer.play("from_left")
	$MusicIntro.play()

func _process(delta):
	pass
