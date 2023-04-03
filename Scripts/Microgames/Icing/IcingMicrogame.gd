extends Node2D

@onready var end_display = $UI/EndUI
@onready var cake = $Cake

var score = 0

signal game_ended(results)

func _on_spatula_completed():
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

func _on_spatula_layer_applied():
	cake.frame += 1
