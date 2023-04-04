extends Node2D

@export var upgraded : bool = false : set = set_upgraded

@onready var arm = $StirHand
@onready var end_display = $UI/EndUI

const UP_ROUNDS : int = 6
const UP_SPEED : int = 2

var success = false
signal game_ended(results)

func _ready():
	if upgraded:
		arm.set_upgrade(UP_ROUNDS, UP_SPEED)

func set_upgraded(status : bool):
	upgraded = status

func _on_stir_hand_completed():
	# show the game is done 
	end_display.show()
	
	# evaluate: success once completed
	success = true
	# print(success)

	# signal end
	await get_tree().create_timer(1.0).timeout
	emit_signal("game_ended", success)
