extends Node2D

@onready var bowl = $Bowl
@onready var dough = $Dough

const MIN_TILT = -30
const MAX_TILT = 45

var cur_tilt = 0
var tilt_rate = 1

signal pour_started(tilt)
signal pour_stopped

func _ready():
	bowl.rotation_degrees = -45

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# tilt the hand based on input
	if Input.is_action_pressed("left") && cur_tilt > MIN_TILT:
		bowl.rotation_degrees -= tilt_rate
	elif Input.is_action_pressed("right") && cur_tilt < MAX_TILT:
		bowl.rotation_degrees += tilt_rate
	
	cur_tilt = bowl.rotation_degrees
	
	# show/hide the dough depending on the tilt angle
	if cur_tilt > MIN_TILT:
		dough.show()
		emit_signal("pour_started", cur_tilt)
	else:
		dough.hide()
		emit_signal("pour_stopped")


