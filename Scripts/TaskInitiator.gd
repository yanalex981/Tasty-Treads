@tool
class_name TaskInitiator
extends Area2D

@export var enabled : bool = true
@export var target_scene : PackedScene
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

func _ready():
#	assert(target_scene != null, "Target scene can't be null")
#	assert(target_scene) # TODO figure out the minigame scene interface
	pass

func _input(_event):
	pass

func _physics_process(_delta):
	pass

func update_proximity_sprite_offset():
	var zone_bounds = $effect_sprite.get_rect().size.abs()
	var icon_bounds = $proximity_icon.get_rect().size.abs()
	$proximity_icon.position = Vector2(0, zone_bounds.y + icon_bounds.y) / -2

func _get_configuration_warnings():
	var warnings = []
	if target_scene == null:
		warnings.append("Don't forget to configure the target scene to be launched when the player interacts with this object!")
	return warnings

func _on_area_entered(area):
	if enabled:
		$proximity_icon.visible = true
	else:
		$proximity_icon.visible = false

func _on_area_exited(area):
	$proximity_icon.visible = false
