@tool
class_name TaskInitiator
extends Area2D

signal invoked

@export var interact_input_map : String
@export var enabled : bool = true:
	set(value):
		enabled = value
		if not enabled:
			$proximity_icon.visible = false
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

func _input(_event):
	if enabled and Input.is_action_pressed(interact_input_map):
		emit_signal("invoked")

func update_proximity_sprite_offset():
	var zone_bounds = $effect_sprite.get_rect().size.abs()
	var icon_bounds = $proximity_icon.get_rect().size.abs()
	$proximity_icon.position = Vector2(0, zone_bounds.y + icon_bounds.y) / -2

func _on_area_entered(_area):
	if enabled:
		$proximity_icon.visible = true

func _on_area_exited(_area):
	$proximity_icon.visible = false
