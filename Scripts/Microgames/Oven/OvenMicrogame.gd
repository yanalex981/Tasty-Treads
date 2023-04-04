extends Node2D

@export var upgraded : bool = false : set = set_upgraded

@onready var bake_bar = $UI/BakeLevelBar
@onready var timer = $UI/GameTimer
@onready var end_display = $UI/EndUI

var up_bar_under = preload("res://Assets/Microgames/Minigame UI/ovenBarUnder2.png")
var up_bar_progress = preload("res://Assets/Microgames/Minigame UI/ovenBarProgress2.png")
var up_bar_over = preload("res://Assets/Microgames/Minigame UI/ovenBarFrame2.png")

const UP_RATE : int = 5
const UP_METRIC : Array[int] = [52, 81]
const UP_TIME : int = 5

var bake_metric : Array[int] = [55, 76] # 55 to 75 is perfect
var cook_time : int = 8 

var success : bool = false
signal game_ended(results)

func _ready():
	if upgraded:
		# increase speed
		bake_bar.set_fill_rate(UP_RATE)
		# change bar + metric
		bake_bar.texture_over = up_bar_over
		bake_bar.texture_progress = up_bar_progress
		bake_bar.texture_under = up_bar_under
		bake_metric = UP_METRIC
		# decrease cook time
		cook_time = UP_TIME
	
	timer.start(cook_time)

func set_upgraded(status : bool):
	upgraded = status

func _on_game_timer_timeout():
	# show the game ended
	end_display.show()
	
	# evaluate: success when bake level is b/t metric range
	var b = bake_bar.value
	if b >= bake_metric[0] && b < bake_metric[1]:
		success = true
	else:
		success = false
	
#	print(success)

	# close game
	await get_tree().create_timer(1.0).timeout
	emit_signal("game_ended", success)
