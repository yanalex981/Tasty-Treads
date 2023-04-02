extends Sprite2D

@onready var progress_bar = $StirProgressBar
const SEQUENCE = ["up", "right", "down", "left"]
const TOTAL_ROUNDS = 10

var sequence_tracker = []
var num_rounds = 0
var keys_pressed = 0

signal completed

func _process(delta):
	var progress_step = progress_bar.max_value / TOTAL_ROUNDS / SEQUENCE.size()
	
	if Input.is_action_just_pressed("up") && sequence_tracker.is_empty():
		sequence_tracker.append("up")
		keys_pressed = 1
		frame = (frame + 1) % hframes
		progress_bar.value += progress_step
	elif Input.is_action_just_pressed("right") && !sequence_tracker.is_empty() && sequence_tracker[keys_pressed-1] == "up":
		sequence_tracker.append("right")
		keys_pressed = 2
		frame = (frame + 1) % hframes
		progress_bar.value += progress_step
	elif Input.is_action_just_pressed("down") && !sequence_tracker.is_empty() && sequence_tracker[keys_pressed-1] == "right":
		sequence_tracker.append("down")
		keys_pressed = 3
		frame = (frame + 1) % hframes
		progress_bar.value += progress_step
	elif Input.is_action_just_pressed("left") && !sequence_tracker.is_empty() && sequence_tracker[keys_pressed-1] == "down":
		sequence_tracker = []
		keys_pressed = 4
		frame = (frame + 1) % hframes
		progress_bar.value += progress_step
	

	if keys_pressed != 0 && (keys_pressed % SEQUENCE.size() == 0):
		num_rounds += 1
		keys_pressed = 0
	
	if num_rounds == TOTAL_ROUNDS:
		emit_signal("completed")
			
