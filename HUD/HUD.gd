extends CanvasLayer

signal start_game

var can_start = false

func _input(event):
	if event.is_action_pressed("ui_accept") and can_start:
		emit_signal("start_game")

func show_counters():
	$MarginContainer.show()
	$MarginContainer2.show()
	$MarginContainer/AnimationPlayer.play("fade_in")
	$MarginContainer2/AnimationPlayer.play("fade_in")

func hide_counters():
	$MarginContainer2.hide()
	$MarginContainer/AnimationPlayer.play("fade_out")

func update_time(value):
	if value >= 99:
		$MarginContainer/Time.text = "99"
	else:
		$MarginContainer/Time.text = "%0*d" % [2, value]

func update_percent(value):
	if value < 0:
		$MarginContainer/Percent.text = "00%"
	elif value >= 100:
		$MarginContainer/Percent.text = "100%"
	else:
		$MarginContainer/Percent.text = "%0*d" % [2, value] + "%"
		
#	if 0 < value < 10:
#		$MarginContainer/Percent.add_theme_color_override("font_color",  Color(255, 0, 0, 1))
#	elif 10 <= value < 30:
#		$MarginContainer/Percent.add_theme_color_override("font_color",  Color(255, 0, 0, 1))
	
func _ready():
#	update_time(134)
#	update_percent(138)
#	$MarginContainer.hide()
	pass

#print("%0*d" % [2, 3])
# Output: "03"s

#func _process(delta):
#	pass


func _on_start_button_pressed():
	emit_signal("start_game")
	show_counters()
	$StartButton.text = "PLAY AGAIN"
