class_name Droid
extends CharacterBody2D

@export var order_tracker : OrderTracker
@export var order_spawner : OrderSpawner
@export var speed : float = 300

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

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
		self.velocity = direction.normalized() * speed
		
		$tree.direction = direction
		
		move_and_slide()

func _on_nav_agent_target_reached():
	if order_tracker.current_order == null:
		order_tracker.current_order = order_spawner.spawn_order()
		order_tracker.next_step()
		target_position = order_tracker.next_location()
		return
	
	if order_tracker.progress >= order_tracker.current_order.recipe_steps.size():
		order_tracker.complete_order()
		target_position = order_tracker.next_location()
		return
	
	nav_agent.target_position = Vector2.ZERO
#	await get_tree().create_timer(rng.randf_range(0.5, 0.75)).timeout
	await get_tree().create_timer(rng.randf_range(3, 5)).timeout
	order_tracker.next_step()
	
	target_position = order_tracker.next_location()
