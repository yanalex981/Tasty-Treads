extends Node2D

@export var upgraded : bool = true : set = set_upgraded
@export var number_to_clear : int = 8

@onready var spawner = $DecorationSpawner
@onready var arm = $RobotTray
@onready var end_display = $UI/EndUI

const UP_SPEED : int = 1200

var success : bool = false
signal game_ended(results)

func _ready():
	if upgraded:
		arm.set_speed(UP_SPEED)
	
	spawner.spawn_all()

func set_upgraded(status):
	upgraded = status

func _process(_delta):
	if spawner.get_num_caught() == number_to_clear || spawner.num_left == 0:
		# show that the game has ended
		end_display.show()
		get_tree().paused = true
		
		# evaluate: success if requirement is fulfilled
		if spawner.get_num_caught() == number_to_clear:
			success = true
		else:
			success = false
		
#		print(success)
		emit_signal("game_ended", success)
		
		# close game
		await get_tree().create_timer(1.0).timeout
		queue_free()


