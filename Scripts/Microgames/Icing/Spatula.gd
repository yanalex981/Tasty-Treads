extends Sprite2D

@onready var animation_player = $AnimationPlayer

const TOTAL_ROUNDS = 6

var sequence_tracker = []
var num_rounds = 0
var keys_pressed = 0

signal layer_applied
signal completed

func _process(delta):

	if Input.is_action_just_pressed("right") && (sequence_tracker.is_empty() || sequence_tracker[keys_pressed-1] == "left"):
		sequence_tracker.append("right")
		keys_pressed += 1
		animation_player.play("to_right")
	elif Input.is_action_just_pressed("left") && !sequence_tracker.is_empty() && sequence_tracker[keys_pressed-1] == "right":
		sequence_tracker.append("left")
		keys_pressed += 1
		animation_player.play("to_left")
	
	# add layer to cake and reset tracker
	if keys_pressed == 6:
		num_rounds += 1
		emit_signal("layer_applied")
		
		keys_pressed = 0
		sequence_tracker = []
		
	if num_rounds == TOTAL_ROUNDS:
		emit_signal("completed")
		

