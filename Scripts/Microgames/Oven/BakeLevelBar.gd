extends TextureProgressBar

@onready var lull_timer = $LullTimer

var mashing = false
var fill_rate = 3
var deplete_rate = 0.8

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		mashing = true
		value += fill_rate
		lull_timer.start(0.12)
	
	if !mashing and value > 0:
		value -= deplete_rate
	

func _on_lull_timer_timeout():
	mashing = false
