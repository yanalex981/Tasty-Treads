extends Node2D

@export var beat_scene: PackedScene
@onready var spawn_position = $"BeatSpawnLocation"

const NUM_BEATS: int = 12
const TIME_TO_SPAWN: int = 4 # IMPORTANT: Needs to be a multiple of BEATS_TO_MOVE parameter from Beat class or timing messes up. Currently working with double value.
const TIME_INCREASE_VALUE: int = 10 #IMPORTANT: Needs to be a multiple of BEAT_SPEED parameter from Beat class or timing messes up. Currently working with equal value.

var timeSinceSpawn = 0
var totalBeatsSpawned = 0
var activeBeats = []

func _ready():
	var beat = beat_scene.instantiate()
	get_parent().add_child.call_deferred(beat)
	beat.global_position = spawn_position.position
	totalBeatsSpawned += 1
	activeBeats.push_back(beat)

func _process(delta):
	timeSinceSpawn += TIME_INCREASE_VALUE * delta
	if timeSinceSpawn >= TIME_TO_SPAWN and totalBeatsSpawned < NUM_BEATS:
		timeSinceSpawn = 0
		var beat = beat_scene.instantiate()
		get_parent().add_child.call_deferred(beat)
		beat.global_position = spawn_position.position
		totalBeatsSpawned += 1
		activeBeats.push_back(beat)
	
	elif totalBeatsSpawned >= NUM_BEATS and activeBeats.size() == 0:
		pass # Replace with code for closing
	
	# ---------- Button Input ---------- #
	if Input.is_action_just_pressed("ui_accept"):
		calculate_points()

func calculate_points():
	if activeBeats.size() > 0:
		activeBeats.pop_front().delete()


