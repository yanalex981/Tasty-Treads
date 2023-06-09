extends Node2D

@onready var animation_player = $AnimationPlayer

signal smoke_gone

func _ready():
	var idle_mode = randi_range(0,2)
	if idle_mode == 0:
		animation_player.play("idle")
	elif idle_mode == 1:
		animation_player.play("idle_2")
	else:
		animation_player.play("idle_3")

func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		animation_player.play("dissipate")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dissipate":
		emit_signal("smoke_gone")
		queue_free()
