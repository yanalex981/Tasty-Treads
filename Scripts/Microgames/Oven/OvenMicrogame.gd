extends Node2D

@onready var bake_level = $UI/BakeLevelBar
@onready var end_display = $UI/EndUI

var score = 0
var bake_metric = [0, 29, 55, 76, 100] # 55 to 76 is perfect
signal game_ended(results)

func _on_game_timer_timeout():
	# show the game ended
	end_display.show()
	get_tree().paused = true
	
	# evaluate score
	var b = bake_level.value
	if b >= bake_metric[0] && b < bake_metric[1]:
		score = 0
	elif b >= bake_metric[1] && b < bake_metric[2]:
		score = 50
	elif b >= bake_metric[2] && b < bake_metric[3]:
		score = 100
	else:
		score = 25
	print(score)
	emit_signal("game_ended", score)
	
	# close game
	await get_tree().create_timer(1.0).timeout
	queue_free()
