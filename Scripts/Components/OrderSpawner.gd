@tool
class_name OrderSpawner
extends Node

@export var spawnable_orders : Array[Recipe]

var rng = RandomNumberGenerator.new()

var total_spawn_weighting : int:
	get:
		var weighting = 0
		for recipe in spawnable_orders:
			weighting += recipe.spawn_weighting
		return weighting

func spawn_order():
	var n = rng.randi_range(0, total_spawn_weighting - 1)
	for recipe in spawnable_orders:
		if n >= recipe.spawn_weighting:
			n -= recipe.spawn_weighting
		else:
			return recipe
	return spawnable_orders.back()

#var next_order : Recipe:
#	get:
#		var n = rng.randi_range(0, total_spawn_weighting - 1)
#		for recipe in spawnable_orders:
#			if n >= recipe.spawn_weighting:
#				n -= recipe.spawn_weighting
#			else:
#				return recipe
#		return spawnable_orders.back()

func _get_configuration_warnings():
	if spawnable_orders.size() == 0:
		return ["Don't forget to add recipes so that this thing can spawn something!"]

	if total_spawn_weighting == 0:
		return ["Don't forget to configure the recipe spawn weighting so that it's not 0!"]
	
	return []
