extends Label

@export var num_seconds : int 
@onready var timer = $GameTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = num_seconds
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Time Left: " + str(int(timer.time_left))
