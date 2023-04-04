extends Node2D

@export var upgraded : bool = false : set = set_upgraded

@onready var spawner = $SmokeSpawner
@onready var end_display = $UI/EndUI
@onready var arm = $RobotFan

const UP_SPEED : int = 1200
var clear_target : float = 0.35 # 65% of smoke must be cleared

var success : bool = false
signal game_ended(score)

func _ready():
	if upgraded:
		arm.set_speed(UP_SPEED)

func set_upgraded(status : bool):
	upgraded = status

func _on_game_timer_timeout():
	# show the game ended
	end_display.show()
	get_tree().paused = true
	
	var total_smoke :float = spawner.get_children().size() # count number of markers 
	# evaluate: success when >= 65% smoke is cleared
	if spawner.active_smoke/total_smoke <= clear_target:
		success = true
	else:
		success = false
	
#	print(success)
	emit_signal("game_ended", success)
	
	# close game
	await get_tree().create_timer(1.0).timeout
	queue_free()
