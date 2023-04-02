extends Node2D

@onready var animation_player = $AnimationPlayer


func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		animation_player.play("dissipating")


func _on_hurtbox_area_exited(area):
	if area.name == "Hitbox":
		animation_player.pause()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dissipating":
		get_tree().root.get_child(0).get_child(0).decrease_active()
		queue_free()
