class_name Droid
extends CharacterBody2D

@onready var nav_agent : NavigationAgent2D = $nav_agent

@export var target_position : Area2D

var in_range : bool = false:
	set(value):
		in_range = value

func _ready():
	nav_agent.target_position = target_position.global_position

func _process(_delta):
	if nav_agent.is_target_reachable():
		var next_location = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_location)
		self.velocity = direction.normalized() * 200
		
		if not in_range:
			move_and_slide()

func _on_reachable_area_entered(area):
	if area != target_position:
		return

	nav_agent.target_position = Vector2.ZERO
