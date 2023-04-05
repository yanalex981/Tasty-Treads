extends Node2D

@onready var end_display = $UI/EndUI
@onready var cake = $Cake

var success = false

signal game_ended(results)

func _on_spatula_completed():
	# show the game is done 
	end_display.show()
	
	# evaluate: success once completed
	success = true
	# print(success)

	# close the game
#	await get_tree().create_timer(1.0).timeout
	emit_signal("game_ended", success)

func _on_spatula_layer_applied():
	cake.frame += 1
