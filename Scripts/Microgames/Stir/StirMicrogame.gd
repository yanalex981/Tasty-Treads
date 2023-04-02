extends Node2D

@onready var end_display = $UI/EndUI

var score = 0

signal game_ended(results)

func _on_stir_hand_completed():
	# show the game is done 
	end_display.show()
	get_tree().paused = true
	
	# evaluate score
	score = 100
	# print(score)
	emit_signal("game_ended", score)

	# close the game
	await get_tree().create_timer(1.0).timeout
	queue_free()
