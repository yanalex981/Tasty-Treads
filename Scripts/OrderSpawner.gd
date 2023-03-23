@tool
class_name OrderSpawner
extends Node

@export var spawnable_orders : Array[Recipe]

@onready var rng = RandomNumberGenerator.new()

var total_spawn_weighting : int:
	get:
		var weighting = 0
		for recipe in spawnable_orders:
			weighting += recipe.spawn_weighting
		return weighting

var next_order : Recipe:
	get:
		var n = rng.randi_range(0, total_spawn_weighting - 1)
		for recipe in spawnable_orders:
			if n >= recipe.spawn_weighting:
				n -= recipe.spawn_weighting
			else:
				return recipe
		return spawnable_orders.back()
