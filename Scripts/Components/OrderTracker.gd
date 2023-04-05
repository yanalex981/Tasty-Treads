class_name OrderTracker
extends Node

signal order_changed(order : Recipe)
signal order_completed(earnings)
signal progress_changed(progress : int)

@export var order_source : Interactable
@export var order_destination : Interactable
@export var fridge : Interactable
@export var mixing_bowl : Interactable
@export var cutting_station : Interactable
@export var cooling_station : Interactable
@export var batter_station : Interactable
@export var icing_station : Interactable
@export var sprinkling_station : Interactable
@export var oven : Interactable

@export var invisible : bool = false

@onready var highlights = [order_source, order_destination, fridge, mixing_bowl, cutting_station, cooling_station, batter_station, icing_station, sprinkling_station, oven]

@onready var current_order : Recipe:
	set(order):
		current_order = order
		progress = 0
		emit_signal("order_changed", order)

var progress : int = 0:
	set(value):
		var progress_max = 0
		if current_order != null:
			progress_max = current_order.recipe_steps.size()
		progress = clamp(value, 0, progress_max)
		emit_signal("progress_changed", value)
		_update_highlight_visibility()

func _ready():
	_update_highlight_visibility()

func disable_highlights():
	for highlight in highlights:
		highlight.enabled = false

func _update_highlight_visibility():
	if invisible:
		return

	if current_order == null:
		for item in highlights:
			item.enabled = false
		order_source.enabled = true
	elif progress >= current_order.recipe_steps.size():
		for item in highlights:
			item.enabled = false
		order_destination.enabled = true
	else:
		for item in highlights:
			item.enabled = false
		var step = current_order.recipe_steps[progress]
		match step:
			Recipe.TaskType.GET_INGREDIENTS:
				fridge.enabled = true
			Recipe.TaskType.MIX:
				mixing_bowl.enabled = true
			Recipe.TaskType.POUR:
				batter_station.enabled = true
			Recipe.TaskType.CUT_COOKIES:
				cutting_station.enabled = true
			Recipe.TaskType.BAKE:
				oven.enabled = true
			Recipe.TaskType.COOL:
				cooling_station.enabled = true
			Recipe.TaskType.SMEAR_ICING:
				icing_station.enabled = true
			Recipe.TaskType.ADD_SPRINKLES:
				sprinkling_station.enabled = true

func next_step():
	if current_order == null:
		return

	progress += 1

func next_location() -> Area2D:
	if current_order == null:
		return order_source

	if progress >= current_order.recipe_steps.size():
		return order_destination

	var step = current_order.recipe_steps[progress]
	match step:
		Recipe.TaskType.GET_INGREDIENTS:
			return fridge
		Recipe.TaskType.MIX:
			return mixing_bowl
		Recipe.TaskType.POUR:
			return batter_station
		Recipe.TaskType.CUT_COOKIES:
			return cutting_station
		Recipe.TaskType.BAKE:
			return oven
		Recipe.TaskType.COOL:
			return cooling_station
		Recipe.TaskType.SMEAR_ICING:
			return icing_station
		Recipe.TaskType.ADD_SPRINKLES:
			return sprinkling_station
	return null

func complete_order():
	var price = current_order.price
	current_order = null
	emit_signal("order_completed", price)

func _get_configuration_warnings():
	return []
