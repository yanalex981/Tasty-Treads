extends Node2D

var kitchen = preload("res://Scenes/kitchen.tscn")
var upgrade = preload("res://Scenes/UI/UpgradeUI.tscn")

var purchased_upgrades : UpgradesReceipt = UpgradesReceipt.new()

func _ready():
	_show_kitchen_screen(purchased_upgrades, 0)

func _clear_children():
	for node in get_children():
		node.queue_free()

func _show_upgrade_screen(upgrades, cash):
	_clear_children()
	var upgrade_screen = upgrade.instantiate() as UpgradeUI
	add_child(upgrade_screen)
	upgrade_screen.purchased_upgrades = purchased_upgrades
	upgrade_screen.upgrading_finished.connect(_show_kitchen_screen)
	upgrade_screen.money = cash / 100

func _show_kitchen_screen(upgrades, cash):
	_clear_children()
	var kitchen_screen = kitchen.instantiate() as Kitchen
	add_child(kitchen_screen)
	kitchen_screen.purchased_upgrades = purchased_upgrades
	kitchen_screen.earnings = cash * 100
	kitchen_screen.day_is_over.connect(_show_upgrade_screen)
