extends Node2D

@export var beat_scene: PackedScene
@export var hole_scene: PackedScene
@export var cookie_scene: PackedScene

@onready var spawn_position = $"BeatSpawnLocation"
@onready var hole_spawner = get_parent().get_parent().get_child(0).get_child(0) # Points to tree location DoughTray/CookieHoleSpawnPoints
@onready var cookie_spawnpoint = get_parent().get_parent().get_child(2) # Points to tree location CutterMinigame/CookieSpawnPoint

const NUM_BEATS: int = 12
const TIME_TO_SPAWN: int = 4 # IMPORTANT: Needs to be a multiple of BEATS_TO_MOVE parameter from Beat class or timing messes up. Currently working with double value.
const TIME_INCREASE_VALUE: int = 10 #IMPORTANT: Needs to be a multiple of BEAT_SPEED parameter from Beat class or timing messes up. Currently working with equal value.

var timeSinceSpawn = 0
var totalBeatsSpawned = 0
var activeBeats = []
var spawnPointIndex = 0
var holeSpawnLocations
var cookieHeight = 10

func _ready():
	# Spawn the first beat
	var beat = beat_scene.instantiate()
	get_parent().add_child.call_deferred(beat)
	beat.global_position = spawn_position.position
	totalBeatsSpawned += 1
	activeBeats.push_back(beat)
	# Set the hole spawn locations
	holeSpawnLocations = hole_spawner.get_children()

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
		# Create a new hole at the appropriate location
		var newHole = hole_scene.instantiate()
		var beatType = activeBeats[0].beatType 
		newHole.spriteType = beatType
		hole_spawner.add_child.call_deferred(newHole)
		newHole.global_position = holeSpawnLocations[spawnPointIndex].position
		spawnPointIndex += 1
		
		# Place a cookie if the beat was good or perfect
		if beatType == "good" or beatType == "perfect":
			var newCookie = cookie_scene.instantiate()
			get_parent().get_parent().add_child.call_deferred(newCookie)
			# Place the cookie at the spawn point
			newCookie.global_position = cookie_spawnpoint.position
			# Move the spawn point for the next cookie
			cookie_spawnpoint.position.y -= cookieHeight
		
		# Remove the front beat from the queue
		activeBeats.pop_front().delete()


