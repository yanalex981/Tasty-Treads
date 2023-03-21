@tool
extends Node

@export var speed : int = 400

@onready var parent : CharacterBody2D = get_parent()
var direction = Vector2.ZERO :
	set(value):
		direction = value
	get:
		return direction

func _ready():
	pass

func _input(_event):
	if Engine.is_editor_hint():
		return
		
	var new_direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		new_direction += Vector2(0, -1)
	if Input.is_action_pressed("down"):
		new_direction += Vector2(0, 1)
	if Input.is_action_pressed("left"):
		new_direction += Vector2(-1, 0)
	if Input.is_action_pressed("right"):
		new_direction += Vector2(1, 0)

	direction = new_direction.normalized()

func _process(_delta):
	if Engine.is_editor_hint():
		return
		
	parent.velocity = direction * speed
	parent.move_and_slide()

func _get_configuration_warnings():
	var warnings = []

	var _parent = get_parent()

	if _parent == null:
		warnings.append("This node needs to have a parent! Disregard this warning if its scene is being edited")

	if not ("velocity" in _parent and _parent.has_method("move_and_slide")):
		warnings.append("This controller object needs a parent node that has a velocity property and a move_and_slide() method (eg. a CharacterBody2D)")

	return warnings
