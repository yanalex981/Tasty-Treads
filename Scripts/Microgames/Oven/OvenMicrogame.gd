extends Node2D

@onready var bake_level = $UI/BakeLevelBar
@onready var end_display = $UI/EndUI

var score = 0
signal game_ended(results)


func _on_game_timer_timeout():
	# show the game ended
	end_display.show()
	get_tree().paused = true
	
	# evaluate score
	print(score)
	emit_signal("game_ended", score)
	
	# close game
	await get_tree().create_timer(1.0).timeout
	queue_free()
