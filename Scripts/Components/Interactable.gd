@tool
class_name Interactable
extends Area2D

signal invoked

@export var interact_input_map : String
@export var enabled : bool = true:
	set(value):
		enabled = value
		update_effect_sprite_visibility()
		update_proximity_icon_visibility()

@export var effect_sprite : Texture:
	set(sprite):
		effect_sprite = sprite
		$effect_sprite.texture = sprite
		update_proximity_sprite_offset()

@export var proximity_sprite : Texture:
	set(sprite):
		proximity_sprite = sprite
		$proximity_icon.texture = sprite
		update_proximity_sprite_offset()

var in_range : bool = false:
	set(value):
		in_range = value
		
		update_effect_sprite_visibility()
		update_proximity_icon_visibility()

func update_proximity_icon_visibility():
	if not enabled:
		$proximity_icon.visible = false
		return
	
	$proximity_icon.visible = in_range

func update_effect_sprite_visibility():
	$effect_sprite.visible = enabled

func _input(_event):
	if enabled and in_range and Input.is_action_just_released(interact_input_map):
		emit_signal("invoked")

func _ready():
	update_proximity_sprite_offset()
	update_effect_sprite_visibility()
	update_proximity_icon_visibility()

func update_proximity_sprite_offset():
	var zone_bounds = $effect_sprite.get_rect().size.abs()
	var icon_bounds = $proximity_icon.get_rect().size.abs()
	$proximity_icon.position = Vector2(0, zone_bounds.y + icon_bounds.y) / -2

func _on_area_entered(_area):
	in_range = true

func _on_area_exited(_area):
	in_range = false
