extends Node2D

@export var smoke_scene: PackedScene
var active_smoke = 0

func _ready():
	var smoke_positions = get_children()
	place_smoke(smoke_positions)
	

func place_smoke(positions):
	for i in range(positions.size()):
		var marker = positions[i]
		# create smoke
		var smoke = smoke_scene.instantiate()
		get_parent().add_child.call_deferred(smoke)
		active_smoke += 1
		# set position
		smoke.global_position = marker.global_position
		

func decrease_active():
	active_smoke -= 1
	
