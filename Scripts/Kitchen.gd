class_name Kitchen
extends Node2D

signal day_is_over(purchased_upgrades, earnings)

var rng = RandomNumberGenerator.new()

var earnings : int = 0:
	set(value):
		earnings = value
		var dollars = str(value / 100)
		var cents = str(value % 100)
		if cents.length() < 2:
			cents = "0" + cents
		earnings_label.text = "Earnings: $%s.%s" % [dollars, cents]

var purchased_upgrades : UpgradesReceipt = UpgradesReceipt.new():
	set(value):
		purchased_upgrades = value
		
		if purchased_upgrades.droid1Activated:
			var droid = droid_scene.instantiate() as Droid
			droid.order_spawner = order_spawner
			droid.order_tracker = droid1_order_tracker
			player_spawn.add_child(droid)

		if purchased_upgrades.droid2Activated:
			var droid = droid_scene.instantiate() as Droid
			droid.order_spawner = order_spawner
			droid.order_tracker = droid2_order_tracker
			player_spawn.add_child(droid)

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

var droid_scene : PackedScene = preload("res://Scenes/Components/Droid.tscn")

@onready var round_timer : Timer = $round_timer
@onready var time_label : Label = $info_ui/VBoxContainer/panel/padding/time_label
@onready var player_order_tracker : OrderTracker = $kitchen/player_order_tracker
@onready var order_spawner : OrderSpawner = $kitchen/order_spawner
@onready var order_tracker_ui : OrderTrackerDialog = $info_ui/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/order_tracker_ui
@onready var earnings_label : Label = $info_ui/VBoxContainer/panel/padding/earnings_label
@onready var player_spawn : Marker2D = $kitchen/player_spawn
@onready var player : Player = $kitchen/player
@onready var microgame_canvas : CanvasLayer = $microgames
@onready var failSound : AudioStreamPlayer = $MinigameFailSound
@onready var successSound : AudioStreamPlayer = $MinigameSuccessSound
@onready var orderSound : AudioStreamPlayer = $OrderCompleteSound

@onready var droid1_order_tracker : OrderTracker = $kitchen/droid1_order_tracker2
@onready var droid2_order_tracker : OrderTracker = $kitchen/droid2_order_tracker3

func _ready():
	var seconds_remaining = ceil(round_timer.time_left)
	time_label.text = "Time Remaining: %s" % seconds_remaining
	
func _on_order_source_invoked():
	player_order_tracker.current_order = order_spawner.spawn_order()

func _on_destination_highlight_invoked():
	earnings += player_order_tracker.current_order.price
	player_order_tracker.complete_order()

func _game_ended(success):
	if not success:
		player.tips -= 200
		failSound.play()
	else :
		successSound.play()

	player.enabled = true

	for node in microgame_canvas.get_children():
		node.queue_free()
	player_order_tracker.next_step()

func _on_fridge_highlight_invoked():
	var game = fridge_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
	game.connect("game_ended", _game_ended)
	var good = ['Eggs', "Flour", 'Butter']
	var bad = ['FishHead', 'Bottle']
	game.start(good, bad)
	game.set_upgraded(purchased_upgrades.tuneUpActivated)

func _on_mixing_highlight_invoked():
	var game = mixing_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
	game.set_upgraded(purchased_upgrades.whiskActivated)
	game.connect("game_ended", _game_ended)

func _on_batter_highlight_invoked():
	var game = batter_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
#	game.set_upgraded(purchased_upgrades.whiskActivated)
	game.connect("game_ended", _game_ended)

func _on_cutting_highlight_invoked():
	var game = cutting_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
#	game.set_upgraded(purchased_upgrades.whiskActivated)
	game.connect("game_ended", _game_ended)

func _on_icing_highlight_invoked():
	var game = icing_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
#	game.set_upgraded(purchased_upgrades.whiskActivated)
	game.connect("game_ended", _game_ended)

func _on_sprinkle_highlight_invoked():
	var game = sprinkle_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
	game.set_upgraded(purchased_upgrades.whiskActivated)
	game.connect("game_ended", _game_ended)

func _on_oven_highlight_invoked():
	var game = oven_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
	game.set_upgraded(purchased_upgrades.whiskActivated)
	game.connect("game_ended", _game_ended)

func _on_cooling_highlight_invoked():
	var game = cooling_game.instantiate()
	microgame_canvas.add_child(game)
	player_order_tracker.disable_highlights()
	player.enabled = false
	game.set_upgraded(purchased_upgrades.whiskActivated)
	game.connect("game_ended", _game_ended)

func _on_order_changed(order):
	order_tracker_ui.order = order

func _on_progress_changed(progress):
	order_tracker_ui.progress = progress

func _on_round_timer_timeout():
	emit_signal("day_is_over", purchased_upgrades, earnings)

func _update_time_remaining_label():
	var seconds_remaining = ceil(round_timer.time_left)
	time_label.text = "Time Remaining: %ss" % seconds_remaining

func _on_order_completed(earnings):
	_update_earnings()
	orderSound.play()

func _on_player_order_changed(order):
	if order == null:
		return
	
	print(order.price)
	var tips = rng.randi_range(1200, 2000)
	player.tips = tips
	print(tips)

func _on_player_order_completed(earnings):
	player.earnings += int(earnings)
	player.earnings += player.tips
	player.tips = 0

	_update_earnings()

func _update_earnings():
	var sum = 0
	for node in player_spawn.get_children():
		if node is Droid:
			sum += node.earnings

	sum += player.earnings
	earnings = sum
