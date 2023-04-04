class_name Droid
extends CharacterBody2D

@export var order_tracker : OrderTracker
@export var order_spawner : OrderSpawner

@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var target_position : Area2D:
	set(value):
		target_position = value
		nav_agent.target_position = value.global_position

func _ready():
	target_position = order_tracker.next_location()

func _process(_delta):
	if nav_agent.is_target_reachable():
		var next_location = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_location)
		self.velocity = direction.normalized() * 500
		
		move_and_slide()

func _on_reachable_area_entered(area):
	if area != target_position:
		return

func _on_nav_agent_target_reached():
	if order_tracker.current_order == null:
		order_tracker.current_order = order_spawner.spawn_order()

#	await get_tree().create_timer(2.0).timeout

	order_tracker.next_step()
	target_position = order_tracker.next_location()
	nav_agent.target_position = target_position.global_position
