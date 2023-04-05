extends Node2D

@export var decor_scene: PackedScene
@export var num_decorations: int = 12
@onready var progress_label = $ProgressLabel
@onready var tray = get_parent().get_child(2) # Points to tree location DecorationMicrogame/RobotTray

const MAX_GRAVITY : float = 2
const MIN_GRAVITY : float = 0.7

var screen_size: Vector2 # used to calculate spawn position
var num_caught : int = 0 : get = get_num_caught
var num_left : int = num_decorations
var lifetime : float = 2 # how long a sprinkle lives before destruction
var delay : float = 0.3 # time between sprinkle spawns

var bodies = [] # Used to track all added bodies

func _ready():
	screen_size = get_viewport_rect().size 

func get_num_caught() -> int:
	return num_caught

func spawn_decor():
	var decor = decor_scene.instantiate()
	get_parent().add_child(decor)
	
	# resize the object
	var sprite = decor.get_node("Sprite")
	sprite.scale = Vector2(0.6, 0.6)
	var collision_shape = decor.get_node("CollisionShape2D")
	collision_shape.shape.radius = 25
	
	# set spawn position (random)
	var margin = 150
	var x_pos = randf_range(margin, screen_size.x - margin)
	var texture_height = decor.get_child(0).texture.get_height()
	decor.position = Vector2(x_pos, -texture_height)
	
	# set how fast it falls
	decor.gravity_scale = randf_range(MIN_GRAVITY, MAX_GRAVITY)
	
	# destroy the decorations after a certain amount of time
	await get_tree().create_timer(lifetime).timeout
	if decor != null:
		num_left -= 1
		decor.queue_free()
	
func spawn_all():
	# make all decorations fall
	for i in range(num_decorations):
		spawn_decor()
		await get_tree().create_timer(delay).timeout
	

func increase_caught():
	num_caught += 1 
	progress_label.text = str(num_caught)


func _on_catch_box_body_entered(body):
	if body is RigidBody2D:
		increase_caught()
		num_left -= 1
		# Create a new decoration sprite
		var decor = body.get_node("Sprite").duplicate()
		tray.add_child(decor)
		# Move the new sprite to the position of the body that was just caught
		decor.global_position.x = body.global_position.x
		decor.global_position.y = body.global_position.y
		# Delete the old body
		body.queue_free()
