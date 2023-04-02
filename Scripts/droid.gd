extends CharacterBody2D

@onready var sprite = $"sprite"
@onready var navigation = $"NavigationAgent2D"

const SPEED = 400
var direction = Vector2.ZERO
var nextPathPosition

func _physics_process(delta):
	# ---------- Path finding to next objective ---------- #
	nextPathPosition = navigation.get_next_path_position()
	direction = (nextPathPosition - position).normalized()
	
	# When the distance between current position and target position is miniscule, stop moving
	if (nextPathPosition - position).length() < 10:
		direction = Vector2.ZERO
	
	velocity = direction * SPEED
	
	# ---------- Handling Animations ---------- #
	if direction.x > 0:
		sprite.play("right")
	elif direction.x < 0:
		sprite.play("left")
	elif direction.y > 0:
		sprite.play("down")
	elif direction.y < 0:
		sprite.play("up")
	else:
		sprite.set_frame_and_progress(0, 0)
	
	move_and_slide()


func update_destination(newDestination):
	navigation.set_target_position(newDestination)
