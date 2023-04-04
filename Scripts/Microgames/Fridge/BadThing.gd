extends Sprite2D

func _on_hurtbox_area_entered(area):
	if area.name == "HitBox":
		get_tree().root.get_child(0).set_bad()
		queue_free()

