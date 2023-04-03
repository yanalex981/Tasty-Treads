extends Node2D

@onready var spawner = $"BeatSpawner"


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("Areas centered at (%s, %s)" % [$"TimingBar/PerfectArea/CollisionShape2D".global_position.x, $"TimingBar/PerfectArea/CollisionShape2D".global_position.y])
	#print("Spawn location at (%s, %s)" % [$"TimingBar/BeatSpawner/BeatSpawnLocation".global_position.x, $"TimingBar/BeatSpawner/BeatSpawnLocation".global_position.y])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
