extends Node2D

func _on_order_source_invoked():
	$order_tracker.current_order = $order_spawner.next_order

func _on_destination_highlight_invoked():
	$order_tracker.complete_order()

func _on_fridge_highlight_invoked():
	$order_tracker.next_step()

func _on_mixing_highlight_invoked():
	$order_tracker.next_step()

func _on_batter_highlight_invoked():
	$order_tracker.next_step()

func _on_cutting_highlight_invoked():
	$order_tracker.next_step()

func _on_icing_highlight_invoked():
	$order_tracker.next_step()

func _on_sprinkle_highlight_invoked():
	$order_tracker.next_step()

func _on_oven_highlight_invoked():
	$order_tracker.next_step()

func _on_cooling_highlight_invoked():
	$order_tracker.next_step()

func _on_order_changed(order):
	$info_ui/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/order_tracker_ui.order = order

func _on_progress_changed(progress):
	$info_ui/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/order_tracker_ui.progress = progress
