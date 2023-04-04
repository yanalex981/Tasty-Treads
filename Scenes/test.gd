extends Node2D

func _input(_event):
	get_viewport().set_input_as_handled()

func _on_timer_timeout():
	print("ended")
	queue_free()
