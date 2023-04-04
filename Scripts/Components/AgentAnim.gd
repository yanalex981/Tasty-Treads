class_name AgentAnim
extends AnimationTree

var direction : Vector2 = Vector2.ZERO:
	set(value):
		direction = value
		if value.length() > 0:
			get("parameters/playback").travel("walk")
			set("parameters/walk/blend_position", value)
			set("parameters/idle/blend_position", value)
		else:
			get("parameters/playback").travel("idle")

func _input(_event):
	var new_direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		new_direction += Vector2(0, -1)
	if Input.is_action_pressed("down"):
		new_direction += Vector2(0, 1)
	if Input.is_action_pressed("left"):
		new_direction += Vector2(-1, 0)
	if Input.is_action_pressed("right"):
		new_direction += Vector2(1, 0)

	direction = new_direction.normalized()
