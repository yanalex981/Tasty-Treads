extends Node2D

@onready var pan = $Pan
@onready var pan_player = $Pan/AnimationPlayer
@onready var bowl = $RobotBowl
@onready var end_display = $UI/EndUI

const BEST_FILL_FRAME = 4
const BIG_OVERFLOW_FRAME = 7

var anim_started = false
var anim_speeds = [0.5, 1.5, 3]
var tilt_intervals = [-30, -15, 0, 45]
var score = 0

signal game_ended(results)

func _process(_delta):
	if Input.is_action_just_pressed("interact") || pan_player == null:
		end_display.show()
		get_tree().paused = true
		
		# evaluate score
		var fill_state = pan.frame 
		
		if fill_state >= BEST_FILL_FRAME:
			score = BEST_FILL_FRAME
		else:
			score = fill_state
		
		# apply penalty if too much dough is poured
		var penalty = 0
		if fill_state == BIG_OVERFLOW_FRAME:
			penalty = (fill_state - BEST_FILL_FRAME)*0.75 #bigger penalty here
			score -= penalty
		elif fill_state > BEST_FILL_FRAME :
			penalty = (fill_state - BEST_FILL_FRAME)*0.25
			score -= penalty
		
		score = (score/BEST_FILL_FRAME) * 100
		print(score)
		emit_signal("game_ended", score)
		
		# close game
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_robot_bowl_pour_started(tilt):
	if (pan_player == null):
		return
	
	# adjust speed (or amount filled) depending on the angle
	if !anim_started:
		#begin filling
		anim_started = true
		pan_player.play("fill_up")
	elif tilt > tilt_intervals[0] && tilt < tilt_intervals[1]:
		pan_player.play() # continue fill
		pan_player.speed_scale = anim_speeds[0] # change speed
	elif tilt > tilt_intervals[1] && tilt < tilt_intervals[2]:
		pan_player.play()
		pan_player.speed_scale = anim_speeds[1]
	elif tilt > tilt_intervals[2] && tilt < tilt_intervals[3]:
		pan_player.play()
		pan_player.speed_scale = anim_speeds[2]

func _on_robot_bowl_pour_stopped():
	# stop the fill
	pan_player.pause()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'fill_up':
		pan_player.queue_free()
