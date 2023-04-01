extends CharacterBody2D

const SPEED := 500

func _physics_process(delta):
		# move the hand based on input
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
		
	move_and_slide()
