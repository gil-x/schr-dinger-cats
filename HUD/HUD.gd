extends CanvasLayer

signal start_game

var can_start = false

func _input(event):
	if event.is_action_pressed("ui_accept") and can_start:
		emit_signal("start_game")

func show_counters():
	$MarginContainer.show()
	$MarginContainer2.show()
	$MarginContainer3.show()
	$MarginContainer/AnimationPlayer.play("fade_in")
	$MarginContainer2/AnimationPlayer.play("fade_in")
	$MarginContainer3/AnimationPlayer.play("fade_in")

func hide_counters():
	$MarginContainer2.hide()
	$MarginContainer3.hide()
	$MarginContainer/AnimationPlayer.play("fade_out")

func show_buttons():
	$StartButton.show()
	$CreditsToogle.show()

func hide_buttons():
	$StartButton.hide()
	$CreditsToogle.hide()

func update_time(value):
	if value >= 99:
		$MarginContainer/Time.text = "99"
	else:
		$MarginContainer/Time.text = "%0*d" % [2, value]

func update_percent(value):
	if value < 0:
		$MarginContainer/Percent.text = "00%"
	elif value >= 100:
		$MarginContainer/Percent.text = "99%"
	else:
		$MarginContainer/Percent.text = "%0*d" % [2, value] + "%"

func _on_start_button_pressed():
	emit_signal("start_game")
	show_counters()
	$StartButton.text = "PLAY AGAIN"

func _on_credit_toogle_pressed():
	if $Credits.visible:
		$Credits.visible = false
		$StartButton.visible = true
		$CreditToogle/Button.text = "Credits"
	else:
		$Credits.visible = true
		$StartButton.visible = false
		$CreditToogle/Button.text = "Close"
