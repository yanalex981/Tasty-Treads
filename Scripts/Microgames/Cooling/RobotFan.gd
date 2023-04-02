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
	
	# stop and start the fan on input
	if Input.is_action_pressed("interact"):
		blow_air()
	if Input.is_action_just_released("interact"):
		stop_air()
	
	move_and_slide()

func blow_air():
	animation_player.play("blow_air")

func stop_air():
	animation_player.play("RESET")
