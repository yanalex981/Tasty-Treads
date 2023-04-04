extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@export var speed : int = 400 : set = set_speed

func _physics_process(_delta):
	# move the hand based on input
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	elif Input.is_action_pressed("right"):
		velocity.x = speed
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("down"):
		velocity.y = speed
	elif Input.is_action_pressed("up"):
		velocity.y = -speed
	else:
		velocity.y = 0
	
	if Input.is_action_just_pressed("interact"):
		grab_item()

	velocity = velocity.normalized() * speed # normalize so that diagonals move at same speed
	move_and_slide()

func set_speed(new_speed : int):
	speed = new_speed

func grab_item():
	animation_player.play("grab_item")
	print("grabbed")
