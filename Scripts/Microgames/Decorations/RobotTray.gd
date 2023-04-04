extends CharacterBody2D

@export var speed : int = 900 : set = set_speed

func _physics_process(delta):
		# move the hand based on input
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	elif Input.is_action_pressed("right"):
		velocity.x = speed
	else:
		velocity.x = 0
		
	move_and_slide()

func set_speed(new_speed : int):
	speed = new_speed
