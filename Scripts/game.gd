extends Node2D

var kitchen = preload("res://Scenes/kitchen.tscn")
var upgrade = preload("res://Scenes/UI/UpgradeUI.tscn")

func _ready():
	_show_kitchen_screen()

func _clear_children():
	for node in get_children():
		node.queue_free()

func _show_upgrade_screen():
	_clear_children()
	var upgrade_screen = upgrade.instantiate() as UpgradeUI
	upgrade_screen.upgrading_finished.connect(_show_kitchen_screen)
	add_child(upgrade_screen)

func _show_kitchen_screen():
	_clear_children()
	var kitchen_screen = kitchen.instantiate() as Kitchen
	kitchen_screen.day_is_over.connect(_show_upgrade_screen)
	add_child(kitchen_screen)
