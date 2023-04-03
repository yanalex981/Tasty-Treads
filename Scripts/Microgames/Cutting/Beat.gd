extends Node2D

const BEATS_TO_MOVE: int = 2
const MOVE_VALUE: int = 60
const BEAT_SPEED: int = 10

var beatsSinceMove = 0
var beatType = "bad" # Used to tell where along bar player presses space. Used for points calculation.
var disappearSpeed = 3
var disappearing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !disappearing:
		beatsSinceMove += BEAT_SPEED * delta
		if beatsSinceMove >= BEATS_TO_MOVE:
			beatsSinceMove = 0
			position.x -= MOVE_VALUE
	else:
		modulate.a -= disappearSpeed * delta
		if modulate.a <= 0:
			queue_free()

func _on_hurtbox_area_entered(area):
	if area.name == "EndOfBar":
		delete()
	elif area.name == "GoodArea":
		beatType = "good"
	elif area.name == "PerfectArea":
		beatType = "perfect"

func _on_hurtbox_area_exited(area):
	if area.name == "PerfectArea":
		beatType = "good"
	elif area.name == "GoodArea":
		beatType = "bad"

func delete():
	if beatType == "bad":
		$BadSprite.visible = true
	elif beatType == "good":
		$GoodSprite.visible = true
	elif beatType == "perfect":
		$PerfectSprite.visible = true
	$sprite.visible = false
	disappearing = true
