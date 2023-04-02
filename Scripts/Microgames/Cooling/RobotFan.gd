extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
const SPEED := 600

func _ready():
	pass

func _physics_process(_delta):
	# move the hand based on input
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
	else:
		velocity.y = 0

	move_and_slide()

