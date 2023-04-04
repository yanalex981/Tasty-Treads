extends Node2D

@onready var bowl = $Bowl
@onready var dough = $Dough

const MIN_TILT : int = -30 # degrees in rotation
const MAX_TILT : int = 45

var cur_tilt : float = 0
var tilt_rate : int = 1

signal pour_started(tilt)
signal pour_stopped

func _ready():
	# set initial tilt degress
	bowl.rotation_degrees = -45
	dough.apply_scale(Vector2(0.5,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# tilt the bowl based on input
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


