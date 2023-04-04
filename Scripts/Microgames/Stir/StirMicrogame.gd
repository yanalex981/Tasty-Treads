extends Node2D

@onready var end_display = $UI/EndUI

var success = false

signal game_ended(results)

func _on_stir_hand_completed():
	# show the game is done 
	end_display.show()
	get_tree().paused = true
	
	# evaluate: success once completed
	success = true
	# print(success)
	emit_signal("game_ended", success)

	# close the game
	await get_tree().create_timer(1.0).timeout
	queue_free()
