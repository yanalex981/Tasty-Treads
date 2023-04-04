class_name Kitchen
extends Node2D

signal day_is_over

var purchased_upgrades : UpgradesReceipt = UpgradesReceipt.new()

# no upgrades
var fridge_game : PackedScene = preload("res://Scenes/Microgames/FridgeMicrogame.tscn")
var batter_game : PackedScene = preload("res://Scenes/Microgames/PouringMicrogame.tscn")
var icing_game : PackedScene = preload("res://Scenes/Microgames/IcingMicrogame.tscn")
var sprinkle_game : PackedScene = preload("res://Scenes/Microgames/DecorationMicrogame.tscn")
var cooling_game : PackedScene = preload("res://Scenes/Microgames/CoolingMicrogame.tscn")

# has upgrades
var mixing_game : PackedScene = preload("res://Scenes/Microgames/StirMicrogame.tscn")
var cutting_game : PackedScene = preload("res://Scenes/Microgames/CutterMicrogame.tscn")
var oven_game : PackedScene = preload("res://Scenes/Microgames/OvenMicrogame.tscn")

func _ready():
	var seconds_remaining = ceil($round_timer.time_left)
	$info_ui/VBoxContainer/panel/padding/time_label.text = "Time Remaining: %s" % seconds_remaining

func _on_order_source_invoked():
	$player_order_tracker.current_order = $order_spawner.next_order

func _on_destination_highlight_invoked():
	$player_order_tracker.complete_order()

func _on_fridge_highlight_invoked():
	$player_order_tracker.next_step()

func _on_mixing_highlight_invoked():
	$player_order_tracker.next_step()

func _on_batter_highlight_invoked():
	$player_order_tracker.next_step()

func _on_cutting_highlight_invoked():
	$player_order_tracker.next_step()

func _on_icing_highlight_invoked():
	$player_order_tracker.next_step()

func _on_sprinkle_highlight_invoked():
	$player_order_tracker.next_step()

func _on_oven_highlight_invoked():
	$player_order_tracker.next_step()

func _on_cooling_highlight_invoked():
	$player_order_tracker.next_step()

func _on_order_changed(order):
	$info_ui/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/order_tracker_ui.order = order

func _on_progress_changed(progress):
	$info_ui/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/order_tracker_ui.progress = progress

func _on_round_timer_timeout():
	emit_signal("day_is_over", purchased_upgrades)

func _update_time_remaining_label():
	var seconds_remaining = ceil($round_timer.time_left)
	$info_ui/VBoxContainer/panel/padding/time_label.text = "Time Remaining: %s" % seconds_remaining
