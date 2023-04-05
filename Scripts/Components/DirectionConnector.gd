class_name DirectionDataConnector
extends Node

@export var source : Node:
	set(value):
		if source != null:
			source.disconnect("direction_changed", _on_direction_changed)
		source = value
		value.connect("direction_changed", _on_direction_changed)

@export var destination : Node

func _on_direction_changed(direction):
	if destination == null:
		return

	destination.direction = direction
