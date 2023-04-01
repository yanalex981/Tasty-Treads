extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer
const SPEED := 500

func _physics_process(delta):
	# move the hand based on input
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("down"):
		velocity.y = SPEED
	elif Input.is_action_pressed("up"):
		velocity.y = -SPEED
	else:
		velocity.y = 0
	
	if Input.is_action_just_pressed("interact"):
		grab_item()

	velocity = velocity.normalized() * SPEED # normalize so that diagonals move at same speed
	move_and_slide()
	
func grab_item():
	_animation_player.play("grab_item")
