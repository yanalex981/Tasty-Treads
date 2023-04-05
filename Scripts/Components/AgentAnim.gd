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
