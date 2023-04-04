extends Sprite2D

signal caught_is_bad

func _on_hurtbox_area_entered(area):
	if area.name == "HitBox":
		emit_signal("caught_is_bad")
		queue_free()

