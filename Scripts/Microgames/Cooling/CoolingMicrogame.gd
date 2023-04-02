extends Node2D

@onready var spawner = $SmokeSpawner
@onready var end_display = $UI/EndUI

const TOTAL_SMOKE : int = 12
var score : int = 0

signal game_ended(score)

func _on_game_timer_timeout():
	# show the game ended
	end_display.show()
	get_tree().paused = true
	
	# evaluate score
	var smoke_left = spawner.active_smoke
	score = ((TOTAL_SMOKE - smoke_left) / TOTAL_SMOKE) * 100
	print(score)
	emit_signal("game_ended", score)
	
	# close game
	await get_tree().create_timer(1.0).timeout
	queue_free()
