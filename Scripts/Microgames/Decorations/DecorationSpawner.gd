extends Node2D

@export var decor_scene: PackedScene
@export var num_decorations: int = 12
@onready var progress_label = $ProgressLabel

const MAX_GRAVITY = 2
const MIN_GRAVITY = 0.7

var screen_size: Vector2
var num_caught = 0
var num_left = num_decorations
var lifetime = 2
var delay = 0.3

func _ready():
	screen_size = get_viewport_rect().size 

	
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
	
	# set velocity 
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
		body.queue_free()
