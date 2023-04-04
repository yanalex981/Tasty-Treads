extends TextureProgressBar

@onready var lull_timer = $LullTimer # leeway timer for no input
@export var leeway : float = 0.12

var mashing : bool = false
var fill_rate : int = 3 : set = set_fill_rate # how much an input can increase progress
var deplete_rate : float = 0.8 # how no input can decrease progress

func _process(_delta):
	# increase progress when mashing
	if Input.is_action_just_pressed("interact"):
		mashing = true
		value += fill_rate
		lull_timer.start(leeway) # start checking whether there's no input
	
	# decrease progress if player has started mashing and stopped
	if !mashing and value > 0:
		value -= deplete_rate
	
# turn state to not mashing
func _on_lull_timer_timeout():
	mashing = false

func set_fill_rate(new_rate : int):
	fill_rate = new_rate
