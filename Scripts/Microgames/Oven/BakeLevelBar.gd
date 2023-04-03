extends TextureProgressBar

@onready var lull_timer = $LullTimer


func _process(delta):
	if Input.is_action_just_pressed("interact"):
		value += 1

func _on_lull_timer_timeout():
	pass
