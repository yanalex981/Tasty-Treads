extends Node2D

@export var beat_scene: PackedScene
@export var hole_scene: PackedScene
@export var cookie_scene: PackedScene

@onready var spawn_position = $"TimingBar/BeatSpawner/BeatSpawnLocation"
@onready var hole_spawner = $"DoughTray/CookieHoleSpawnPoints" # Points to tree location DoughTray/CookieHoleSpawnPoints
@onready var cookie_spawnpoint = $"CookieSpawnPoint" # Points to tree location CutterMinigame/CookieSpawnPoint
@onready var timing_bar = $"TimingBar"
@onready var end_display = $"UI/EndUI"
@onready var cookie_stack = $"CookieStack"

const TIME_TO_SPAWN: int = 4 # IMPORTANT: Needs to be a multiple of BEATS_TO_MOVE parameter from Beat class or timing messes up. Currently working with double value.
const TIME_INCREASE_VALUE: int = 10 #IMPORTANT: Needs to be a multiple of BEAT_SPEED parameter from Beat class or timing messes up. Currently working with equal value.
const SCORE_TO_PASS: int = 60
const GOOD_SCORE = 7
const PERFECT_SCORE = 10

var numBeats = 12
var timeSinceSpawn = 0
var totalBeatsSpawned = 0
var activeBeats = []
var spawnPointIndex = 0
var holeSpawnLocations
var cookieHeight = 10
var baseCookieSpawnX
var score = 0
var upgradeEnabled = false

signal game_ended(score)

func _ready():
	# Spawn the first beat
	var beat = beat_scene.instantiate()
	timing_bar.add_child.call_deferred(beat)
	beat.global_position = spawn_position.position
	totalBeatsSpawned += 1
	activeBeats.push_back(beat)
	# Set the hole spawn locations
	holeSpawnLocations = hole_spawner.get_children()
	
	# Store the base x position of the cookie spawner
	baseCookieSpawnX = cookie_spawnpoint.position.x

func _process(delta):
	timeSinceSpawn += TIME_INCREASE_VALUE * delta
	if timeSinceSpawn >= TIME_TO_SPAWN and totalBeatsSpawned < numBeats:
		timeSinceSpawn = 0
		var beat = beat_scene.instantiate()
		timing_bar.add_child.call_deferred(beat)
		beat.global_position = spawn_position.position
		totalBeatsSpawned += 1
		activeBeats.push_back(beat)
	
	elif totalBeatsSpawned == numBeats and activeBeats.size() == 0:
			# show the game ended
		end_display.show()
		
		emit_signal("game_ended", score)
		
		# close game
		await get_tree().create_timer(1.0).timeout
		queue_free()
	
	elif totalBeatsSpawned > numBeats:
		# If there are ever more beats than cookies to cut, remove excess beats
		activeBeats.pop_back().queue_free()
		totalBeatsSpawned -= 1
	
	# ---------- Button Input ---------- #
	if Input.is_action_just_pressed("ui_accept"):
		calculate_points()

func calculate_points():
	if activeBeats.size() > 0:
		# Behaviour is different when Dual-Wield Cookie Cutters upgrade is active
		if !upgradeEnabled:
			# Create a new hole at the appropriate location
			var newHole = hole_scene.instantiate()
			var beatType = activeBeats[0].beatType 
			newHole.spriteType = beatType
			hole_spawner.add_child.call_deferred(newHole)
			newHole.global_position = holeSpawnLocations[spawnPointIndex].position
			spawnPointIndex += 1
			
			# Increase score based on beat type
			if beatType == "good":
				score += GOOD_SCORE
			elif beatType == "perfect":
				score += PERFECT_SCORE
			
			# Place a cookie if the beat was good or perfect
			if beatType == "good" or beatType == "perfect":
				var newCookie = cookie_scene.instantiate()
				cookie_stack.add_child.call_deferred(newCookie)
				# Place the cookie at the spawn point
				newCookie.global_position = cookie_spawnpoint.position
				# Move the spawn point for the next cookie
				cookie_spawnpoint.position.y -= cookieHeight
				# Offset the cookie spawnpoint x by some random value
				var xOffset = randi_range(-10, 10)
				cookie_spawnpoint.position.x = baseCookieSpawnX + xOffset
		
		# When the ugrade is active, 2 holes need to be spawned per successful cut and the total number of beats decreases
		else:
			# Create a new hole at the appropriate location
			var newHole = hole_scene.instantiate()
			var beatType = activeBeats[0].beatType 
			newHole.spriteType = beatType
			hole_spawner.add_child.call_deferred(newHole)
			newHole.global_position = holeSpawnLocations[spawnPointIndex].position
			spawnPointIndex += 1
			# If the hole was successfully cut, repeat the hole spawn at the next position using the same hole type
			if beatType == "good" or beatType == "perfect":
				newHole = hole_scene.instantiate()
				newHole.spriteType = beatType
				hole_spawner.add_child.call_deferred(newHole)
				newHole.global_position = holeSpawnLocations[spawnPointIndex].position
				spawnPointIndex += 1
				
				# Place the first cookie
				var newCookie = cookie_scene.instantiate()
				cookie_stack.add_child.call_deferred(newCookie)
				# Place the cookie at the spawn point
				newCookie.global_position = cookie_spawnpoint.position
				# Move the spawn point for the next cookie
				cookie_spawnpoint.position.y -= cookieHeight
				# Offset the cookie spawnpoint x by some random value
				var xOffset = randi_range(-10, 10)
				cookie_spawnpoint.position.x = baseCookieSpawnX + xOffset
				
				# Place the second cookie
				newCookie = cookie_scene.instantiate()
				cookie_stack.add_child.call_deferred(newCookie)
				newCookie.global_position = cookie_spawnpoint.position
				# Move the spawn point for the next cookie
				cookie_spawnpoint.position.y -= cookieHeight
				# Offset the cookie spawnpoint x by some random value
				xOffset = randi_range(-10, 10)
				cookie_spawnpoint.position.x = baseCookieSpawnX + xOffset
				
				# Decrease the total spawned beats
				numBeats -= 1
			
			# Increase score based on beat type
			if beatType == "good":
				score += GOOD_SCORE * 2
			elif beatType == "perfect":
				score += PERFECT_SCORE * 2
		
		# Remove the front beat from the queue
		activeBeats.pop_front().delete()
