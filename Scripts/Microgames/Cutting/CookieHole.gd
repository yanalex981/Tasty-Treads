extends Node2D

@onready var good = $"GoodSprite"
@onready var perfect = $"PerfectSprite"

var spriteType = "bad"

func _ready():
	# Randomly pick a rotation for the hole
	var rotate_degrees = randi_range(0, 360)
	good.rotation_degrees = rotate_degrees
	perfect.rotation_degrees = rotate_degrees

func _process(delta):
	setSprite(spriteType)

func setSprite(spriteType):
	if spriteType == "good":
		good.visible = true
	elif spriteType == "perfect":
		perfect.visible = true
