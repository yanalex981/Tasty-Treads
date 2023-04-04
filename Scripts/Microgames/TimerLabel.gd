extends Timer

@onready var label = $TimerLabel

# update timer label
func _process(_delta):
	label.text = "Time Left: " + str(int(time_left))
