extends Sprite2D

@onready var progress_bar = $StirProgressBar
const SEQUENCE = ["up", "right", "down", "left"]

var total_rounds : int = 10 
var frames_per_input : int = 1 

var sequence_tracker : Array[String] = []
var num_rounds : int = 0 
var keys_pressed : int = 0

var progress_step : int = 1
var x_adjust : int = 10 # for the bar (determined visually for now)

signal completed

func _ready():
	# -10 for smiley face overfill
	progress_bar.max_value = (total_rounds * SEQUENCE.size()) + x_adjust
	

func _process(_delta):
	# check and move the hand according to the input sequence
	if Input.is_action_just_pressed("up") && sequence_tracker.is_empty():
		sequence_tracker.append("up")
		keys_pressed = 1
		move_hand()
		progress_bar.value += progress_step
	elif Input.is_action_just_pressed("right") && !sequence_tracker.is_empty() && sequence_tracker[keys_pressed-1] == "up":
		sequence_tracker.append("right")
		keys_pressed = 2
		move_hand()
		progress_bar.value += progress_step
	elif Input.is_action_just_pressed("down") && !sequence_tracker.is_empty() && sequence_tracker[keys_pressed-1] == "right":
		sequence_tracker.append("down")
		keys_pressed = 3
		move_hand()
		progress_bar.value += progress_step
	elif Input.is_action_just_pressed("left") && !sequence_tracker.is_empty() && sequence_tracker[keys_pressed-1] == "down":
		sequence_tracker.append("left")
		keys_pressed = 4
		move_hand()
		progress_bar.value += progress_step
	
	# reset key tracking once a round has completed
	if keys_pressed == 4:
		num_rounds += 1
		keys_pressed = 0
		sequence_tracker = []
	
	if num_rounds == total_rounds:
		emit_signal("completed")
			

func set_upgrade(new_rounds : int, rate : int):
	total_rounds = new_rounds
	x_adjust = -20 # determined visually for now 
	frames_per_input = rate
	progress_step = rate

func move_hand():
	for i in range(frames_per_input):
		frame = (frame + 1) % hframes
