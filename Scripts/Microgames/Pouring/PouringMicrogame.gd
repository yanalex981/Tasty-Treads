extends Node2D

@onready var pan = $Pan
@onready var pan_player = $Pan/AnimationPlayer
@onready var dough_player = $RobotBowl/Dough/AnimationPlayer
@onready var bowl = $RobotBowl
@onready var end_display = $UI/EndUI

const SUCC_RANGE = [3, 5] # 4 is the perfect fill level

var anim_started : bool = false
var anim_speeds : Array[float] = [0.5, 1.5, 3] # speeds for pan filling
var dough_scales : Array[float] = [0.3, 0.5, 1] # scales for dough width when pouring
var tilt_intervals : Array[int] = [-30, -15, 0, 45] 

var success : bool = false
signal game_ended(results)

func _process(_delta):
	# stop game when user hits stop or if the pan overflows
	if Input.is_action_just_pressed("interact") || pan_player == null:
		end_display.show()
		get_tree().paused = true
		
		# evaluate: success when fill level is in success range
		var fill_state = pan.frame 
		if fill_state >= SUCC_RANGE[0] && fill_state <= SUCC_RANGE[1]:
			success = true
		else:
			success = false
		
		print(success)
		emit_signal("game_ended", success)
		
		# close game
		await get_tree().create_timer(1.0).timeout
		queue_free()

# Note: Should probably move bowl and pan under one node and move these functions there.
func _on_robot_bowl_pour_started(tilt : float):
	# instance check
	if (pan_player == null):
		return
	
	# adjust amount poured depending on the angle
	if !anim_started:
		# begin filling
		anim_started = true
		pan_player.play("fill_up")
	elif tilt > tilt_intervals[0] && tilt < tilt_intervals[1]:
		pan_player.play() # continue fill
		pan_player.speed_scale = anim_speeds[0] # change speed
		dough_player.play("pour_slow")
	elif tilt > tilt_intervals[1] && tilt < tilt_intervals[2]:
		pan_player.play()
		pan_player.speed_scale = anim_speeds[1]
		dough_player.play("pour_normal")
	elif tilt > tilt_intervals[2] && tilt < tilt_intervals[3]:
		pan_player.play()
		pan_player.speed_scale = anim_speeds[2]
		dough_player.play("pour_fast")


func _on_robot_bowl_pour_stopped():
	# stop the fill
	pan_player.pause()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'fill_up':
		pan_player.queue_free()
