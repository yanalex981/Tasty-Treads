extends Node2D

@onready var spawner = $DecorationSpawner
@onready var end_display = $UI/EndUI

const MAX_CAUGHT = 8
var score : int = 0

signal game_ended(results)

func _ready():
	spawner.spawn_all()
	

func _process(delta):
	if spawner.num_caught == MAX_CAUGHT || spawner.num_left == 0:
		# show that the game has ended
		end_display.show()
		get_tree().paused = true
		
		# evaluate score
		score = (spawner.num_caught / MAX_CAUGHT) * 100
		#print(score)
		emit_signal("game_ended", score)
		
		# close game
		await get_tree().create_timer(1.0).timeout
		queue_free()


